defmodule TaiShangNftGalleryWeb.AddrLive do
  use TaiShangNftGalleryWeb, :live_view
  alias TaiShangNftGallery.Nft
  @impl true
  def mount(%{"addr"=> addr}, _session, socket) do
    nfts = Nft.get_all(addr)
    {
      :ok,
      socket
      |> assign(:nfts, nfts)
    }
  end

  @impl true
  def handle_event(_key, _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
