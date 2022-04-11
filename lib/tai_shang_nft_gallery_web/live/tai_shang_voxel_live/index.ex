defmodule TaiShangNftGalleryWeb.TaiShangVoxelLive.Index do
  use TaiShangNftGalleryWeb, :live_view
  alias TaiShangNftGallery.{Nft, NftContract}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, init(socket)}
  end

  @impl true
  def handle_event("search", %{"addr" => addr}, socket) do
    payload = Nft.check_owner(addr)
    do_handle_event(payload, addr, socket)

  end

  def handle_event(_key, _value, socket) do
    {:noreply, socket}
  end

  def do_handle_event(payload, _addr, socket) when is_nil(payload) do
    {
      :noreply,
      socket
      |> put_flash(:error, "this addr has not any NFT for the Web3Dev.")
    }
  end

  def do_handle_event(_payload, addr, socket) do
    {
      :noreply,
      socket
      |> redirect(to: Routes.addr_path(socket, :index, %{addr: addr}))
    }
  end

  def init(socket) do
    nft_contract = %{id: id} =
      "Voxel"
      |> NftContract.get_by_name()
      |> NftContract.preload()
    nft_num =
      Nft.count(id)

    nfts =
      nft_contract
      |> NftContract.preload(:nfts)
      |> Map.get(:nfts)

    socket
    |> assign(nft_contract: nft_contract)
    |> assign(nft_num: nft_num)
    |> assign(nfts: nfts)
  end
end
