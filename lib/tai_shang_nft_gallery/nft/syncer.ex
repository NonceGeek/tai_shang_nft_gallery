defmodule TaiShangNftGallery.Nft.Syncer do
  alias TaiShangNftGallery. NftContract
  alias TaiShangNftGallery.TxHandler
  alias TaiShangNftGallery.Chain.Fetcher
  alias TaiShangNftGallery.ScanInteractor
  require Logger

  @api_keys %{
    "Moonbeam" => System.get_env("MOONBEAM_API_KEY"),
    "Polygon" => System.get_env("POLYGON_API_KEY"),
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

end
