defmodule TaiShangNftGallery.TxHandler.Web3Dev do
  alias TaiShangNftGallery.Nft
  alias TaiShangNftGallery.Nft.Interactor
  alias TaiShangNftGallery.TxHandler.NftUtils

  require Logger
  def handle_tx(chain, _hash, nft_contract, from, to, value,
    {%{function: func_name}, data})  do
    # no nessary to handle receipt.
      do_handle_tx(
        func_name,
        nft_contract, from, to, value, data, chain
      )
  end

  def handle_tx(_chain, _hash, _nft_contract, _from, _to, _value, _others) do
    :pass
  end

  # Util Funcs
  def do_handle_tx(func, nft_contract, from, to, value,
    [from_bin, to_bin, token_id], chain) when
    func in ["safeTransferFrom", "transferFrom"] do
      NftUtils.handle_tx(func, nft_contract, from, to, value,
        [from_bin, to_bin, token_id], chain)
  end

  def do_handle_tx("claim", %{id: nft_c_id, addr: addr}, from, _to, _value, [token_id], chain) do
    # INIT Token
    uri = Interactor.get_token_uri(chain, addr, token_id)

    if is_nil(Nft.get_by_token_id_and_nft_contract_id(token_id, nft_c_id)) == true do
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
    try do
      # UPDATE Badges & URI
      uri = Interactor.get_token_uri(chain, addr, token_id)

      token_id
      |> Nft.get_by_token_id_and_nft_contract_id(nft_c_id)
      |> Nft.update(%{
          badges: parse_badge(badges_raw), token_id: token_id, uri: uri
      }, :with_badges) # token_id is necessary for judge
    rescue
      _ ->
        :pass
    end
  end
  def do_handle_tx(_others, _, _, _, _, _, _) do
    {:ok, "pass"}
  end

  # parse the list of badge
  def parse_badge(badges_raw) do
    all_badges =
      get_all_badges(badges_raw)
    all_nums =
      get_all_badge_nums(badges_raw)
    all_badges
    |> Enum.zip(all_nums)
    |> Enum.into(%{})
  end

  def get_all_badges(badges_raw) do
    badges_raw
    |> String.replace("*", "")
    |> String.replace( ~r/\d+/, "")
    |> Poison.decode!()
  end

  def get_all_badge_nums(badges_raw) do
    badges_raw
    |> String.split(",")
    |> Enum.map(fn ele ->
      ele
      |> String.replace(~r/[^\d]/, "")
      |> handle_num()
    end)
  end

  defp handle_num(num) when num == "" do
    1
  end

  defp handle_num(num) do
    String.to_integer(num)
  end
end
