defmodule TaiShangNftGallery.TxHandler.Web3Dev do
  alias TaiShangNftGallery.Nft
  alias TaiShangNftGallery.Nft.Interactor
  alias Utils.TypeTranslator

  require Logger
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

  def do_handle_tx(func, _nft_contract, from, _to, _value,
    [_from_bin, to_bin, token_id], _chain) when
    func in ["safeTransferFrom", "transferFrom"] do
    # Change Owner
    to_str = TypeTranslator.bin_to_addr(to_bin)
    Logger.info("Transfer NFT from #{from} to #{to_str}")
    nft = Nft.get_by_token_id(token_id)
    Nft.update(nft, %{token_id: token_id, owner: to_str})
  end

  def do_handle_tx("claim", %{id: nft_c_id, addr: addr}, from, _to, _value, [token_id], chain) do
    # INIT Token
    uri = Interactor.get_token_uri(chain, addr, token_id)

    if is_nil(Nft.get_by_token_id(token_id)) == true do
      Nft.create(
        %{
          uri: uri,
          token_id: token_id,
          owner: from,
          nft_contract_id: nft_c_id
      })
    else
      :pass
    end

  end
  def do_handle_tx(
    "setTokenInfo",
    %{id: nft_c_id, addr: addr}, _from, _to, _value,
    [token_id, badges_raw], chain) do
    # UPDATE Badges & URI
    uri = Interactor.get_token_uri(chain, addr, token_id)

    token_id
    |> Nft.get_by_token_id_and_nft_contract_id(nft_c_id)
    |> Nft.update(%{
        badges: Poison.decode!(badges_raw), uri: uri
    }, :with_badges)
  end
  def do_handle_tx(_others, _, _, _, _, _, _) do
    {:ok, "pass"}
  end
end
