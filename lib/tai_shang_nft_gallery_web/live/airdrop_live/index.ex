defmodule TaiShangNftGalleryWeb.AirdropLive.Index do
  use TaiShangNftGalleryWeb, :live_view

  alias TaiShangNftGallery.Airdrop

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :airdrops, list_airdrops())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Airdrop")
    |> assign(:airdrop, Airdrop.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Airdrop")
    |> assign(:airdrop, %Airdrop{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Airdrops")
    |> assign(:airdrop, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    airdrop = Airdrop.get!(id)
    {:ok, _} = Airdrop.delete(airdrop)

    {:noreply, assign(socket, :airdrops, list_airdrops())}
  end

  defp list_airdrops do
    Airdrop.list()
  end
end
