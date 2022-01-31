defmodule TaiShangNftGallery.SyncerServer do
  @moduledoc """
    Genserver as Syncer
  """
  alias TaiShangNftGallery.Nft.Syncer
  alias TaiShangNftGallery.NftContract
  use GenServer
  require Logger

  @sync_interval 600_000 # 10 minutes
  # +-----------+
  # | GenServer |
  # +-----------+
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: :"#nft_syncer")
  end

  def init([nft_contract_id: nft_contract_id]) do
    Logger.info("SyncerServer started yet.")
    nft_contract =
      nft_contract_id
      |> NftContract.get_by_id()
      |> NftContract.preload()
      state =
        [nft_contract: nft_contract]
    send(self(), :sync)
    {:ok, state}
  end

  def handle_info(:sync, [nft_contract: nft_contract] = state) do
    Syncer.sync(nft_contract.chain, nft_contract)
    sync_after_interval()
    {:noreply, state}
  end

  def sync_after_interval() do
    Process.send_after(self(), :sync, @sync_interval)
  end

end
