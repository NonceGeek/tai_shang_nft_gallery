defmodule TaiShangNftGalleryWeb.NftLive.Show do
  use TaiShangNftGalleryWeb, :live_view

  alias TaiShangNftGallery.Nft

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:nft, Nft.get_by_id(id))}
  end

  defp page_title(:show), do: "Show Nft"
  defp page_title(:edit), do: "Edit Nft"
end
