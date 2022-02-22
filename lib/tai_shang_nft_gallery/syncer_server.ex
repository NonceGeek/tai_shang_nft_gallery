defmodule TaiShangNftGallery.SyncerServer do
  @moduledoc """
    Genserver as Syncer
  """
  alias TaiShangNftGallery.Nft.Syncer
  alias TaiShangNftGallery.NftContract
  use GenServer
  require Logger

  @sync_interval 60_000 # 1 minutes
  @init_pending_time 5_000 # 5 sec
  # +-----------+
  # | GenServer |
  # +-----------+
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: :nft_syncer)
  end

  @doc """
    init -> hand_info(init) -> sync_routine
  """
  def init(state) do
    Process.send_after(self(), :init, @init_pending_time)
    {:ok, state}
  end

  def handle_info(:init,  [nft_contract_id: nft_contract_id]) do
    Logger.info("SyncerServer started yet.")
    nft_contract =
      nft_contract_id
      |> NftContract.get_by_id()
      |> NftContract.preload()
      state =
        [nft_contract_id: nft_contract_id]

    send(self(), :sync)
    {:noreply, state}
  end

  def handle_info(:sync, [nft_contract_id: nft_contract_id] = state) do
    # reload nft_contract
    nft_contract =
      nft_contract_id
      |> NftContract.get_by_id()
      |> NftContract.preload()
    Syncer.sync(nft_contract.chain, nft_contract)
    sync_after_interval()
    {:noreply, state}
  end

  def sync_after_interval() do
    Process.send_after(self(), :sync, @sync_interval)
  end

end
