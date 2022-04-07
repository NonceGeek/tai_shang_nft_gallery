defmodule TaiShangNftGalleryWeb.NftLive.Index do
  use TaiShangNftGalleryWeb, :live_view

  alias TaiShangNftGallery.Nft

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :nfts, list_nfts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Nft")
    |> assign(:nft, Nft.get_by_id(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Nft")
    |> assign(:nft, %Nft{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Nfts")
    |> assign(:nft, nil)
  end

  defp list_nfts do
    Nft.get_all()
  end
end
