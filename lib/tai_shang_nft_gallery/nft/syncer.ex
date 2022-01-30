defmodule TaiShangNftGallery.Nft.Syncer do
  alias TaiShangNftGallery. NftContract
  alias TaiShangNftGallery.TxHandler
  alias TaiShangNftGallery.Chain.Fetcher
  alias TaiShangNftGallery.ScanInteractor
  require Logger

  @api_keys %{
    "Moonbeam" => System.get_env("MOONBEAM_API_KEY")
  }
  def sync(chain, %{last_block: last_block} = nft_contract) do

    best_block = Fetcher.get_block_number(chain)
    do_sync(chain, nft_contract, last_block, best_block)
    NftContract.update(
      nft_contract,
      %{last_block: best_block + 1}
    )
  end

  def do_sync(%{name: name} = chain, %{addr: addr} = nft_contract, last_block, best_block) do
    {:ok, %{"result" => txs}}=
      ScanInteractor.get_txs_by_contract_addr(
        chain,
        addr,
        last_block,
        best_block,
        @api_keys[name]
      )
    handle_txs(chain, nft_contract, txs)
  end

  def handle_txs(chain, nft_contract, txs) do
    Enum.each(txs, fn tx ->
      Logger.info("Handling tx: #{inspect(tx)}")
      tx_atom_map = ExStructTranslator.to_atom_struct(tx)
      TxHandler.handle_tx(chain, nft_contract, tx_atom_map)
    end)
  end
  # def sync_by_contract(chain,
  #   %{
  #     type: type
  #   } = nft_contract, begin_index, end_index) do

  #   do_sync(chain, nft_contract, type, begin_index, end_index)
  #   # latest =
  #   #   Interactor.get_total_supply(
  #   #     chain,
  #   #     contract_addr
  #   #   )
  #   # update the index
  #   # update_index(nft_contract, latest)
  # end

  # # def update_index(nft_contract, latest) do
  # #   NftContract.update(
  # #     nft_contract,
  # #     %{last_sync_index: latest}
  # #   )
  # # end
  # def do_sync(
  #   chain, nft_contract, type, index_now, latest
  # ) do
  #   Enum.each(
  #     index_now..latest - 1, fn index ->
  #       sync_an_nft(
  #         chain,
  #         nft_contract,
  #         index,
  #         type
  #       )
  #     end
  #   )
  # end


  # # +------------------+
  # # | spec for dif nft |
  # # +------------------+
  # def sync_an_nft(chain, %{addr: addr} = nft_contract, index, "web3dev") do
  #   token_id =
  #     Interactor.get_token_by_index(
  #     chain,
  #     addr,
  #     index
  #   )
  #   badges = get_token_info(chain, addr, token_id)
  #   with false <- is_nil(badges),
  #       true <- token_id <= 2147483647 do
  #       do_sync_an_nft(chain, nft_contract, token_id, badges, "web3dev")
  #   else
  #     _others ->
  #       :pass
  #   end
  # end

  # def create_nft_first_time(uri, token_id, badges, owner, nft_contract_id) do
  #   Nft.create(
  #     %{
  #       uri: uri,
  #       token_id: token_id,
  #       badges: badges,
  #       owner: owner,
  #       nft_contract_id: nft_contract_id
  #   })
  # end

  # def do_sync_an_nft(chain, %{addr: addr, id: id}, token_id, badges, "web3dev") do
  #   nft =
  #     Nft.get_by_token_id_and_nft_contract_id(token_id, id)
  #   owner =
  #     Interactor.query_owner_of(chain, addr, token_id)
  #   if is_nil(nft) do
  #     # token_uri_is_unchangable
  #     chain
  #     |> Interactor.get_token_uri(addr, token_id)
  #     |> create_nft_first_time(token_id, badges, owner, id)
  #   else
  #     # badges and owner is changable
  #     Nft.update(
  #       nft,
  #       %{
  #         badges: badges,
  #         owner: owner
  #       }
  #     )
  #   end
  # end

  # def get_token_info(chain, contract_addr, token_id) do
  #   chain
  #   |> Interactor.get_token_info(contract_addr, token_id)
  #   |> do_get_token_info()
  # end

  # def do_get_token_info(payload) when payload=="" do
  #   nil
  # end
  # def do_get_token_info(payload) do
  #   Poison.decode!(payload)
  # end
end
