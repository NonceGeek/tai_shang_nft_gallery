defmodule TaiShangNftGallery.TxHandler.Web3Dev do
  alias TaiShangNftGallery.Nft
  alias TaiShangNftGallery.Nft.Interactor
  alias Utils.TypeTranslator
  def handle_tx(chain, nft_contract, from, to, value,
    {%{function: func_name}, data})  do
      do_handle_tx(
        func_name,
        nft_contract, from, to, value, data, chain
      )
  end

  def handle_tx(_chain, _nft_contract, _from, _to, _value, _others) do
    :pass
  end

  def do_handle_tx("transferFrom", _nft_contract, _from, _to, _value,
    [_from_bin, to_bin, token_id], _chain) do
    # Change Owner
    to_str = TypeTranslator.bin_to_addr(to_bin)
    nft = Nft.get_by_token_id(token_id)
    Nft.update(nft, %{token_id: token_id, owner: to_str})
  end

  def do_handle_tx("claim", %{id: nft_c_id, addr: addr}, from, _to, _value, [token_id], chain) do
    # INIT Token
    uri = Interactor.get_token_uri(chain, addr, token_id)
    Nft.create(
      %{
        uri: uri,
        token_id: token_id,
        owner: from,
        nft_contract_id: nft_c_id
    })
  end
  def do_handle_tx(
    "setTokenInfo",
    %{id: nft_c_id}, _from, _to, _value,
    [token_id, badges_raw], _chain) do
    # UPDATE TokenInfo

    token_id
    |> Nft.get_by_token_id_and_nft_contract_id(nft_c_id)
    |> Nft.update(%{
        badges: Poison.decode!(badges_raw), token_id: token_id
    }, :with_badges)
  end
  def do_handle_tx(_others, _, _, _, _, _, _) do
    {:ok, "pass"}
  end
end
