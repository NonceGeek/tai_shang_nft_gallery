defmodule TaiShangNftGalleryWeb.AirdropLive.Show do
  use TaiShangNftGalleryWeb, :live_view

  alias TaiShangNftGallery.Airdrop

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:airdrop, Airdrop.get!(id))}
  end

  defp page_title(:show), do: "Show Airdrop"
  defp page_title(:edit), do: "Edit Airdrop"
end
