defmodule TaiShangNftGalleryWeb.SyncerController do
  use TaiShangNftGalleryWeb, :controller
  alias TaiShangNftGallery.{NftSyncer, Chain, NftContract}
  def sync(conn, params) do
    %{
      chain_id: chain_id,
      nft_contract_id: nft_contract_id,
      begin_index: begin_index,
      end_index: end_index,
    } =
      params
      |> value_to_int()
      |> ExStructTranslator.to_atom_struct()
    chain = Chain.get_by_id(chain_id)
    nft_contract_id = NftContract.get_by_id(nft_contract_id)
    NftSyncer.sync(chain, nft_contract_id, begin_index, end_index)
    json(conn, %{result: "syncer_sync_success"})
  end

  def value_to_int(params) do
    params
    |> Enum.map(fn {key, value} ->
      {key, String.to_integer(value)}
    end)
    |> Enum.into(%{})
  end

end
