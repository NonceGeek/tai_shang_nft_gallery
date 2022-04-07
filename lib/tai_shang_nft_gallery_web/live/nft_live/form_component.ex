defmodule TaiShangNftGalleryWeb.NftLive.FormComponent do
  use TaiShangNftGalleryWeb, :live_component

  alias TaiShangNftGallery.Nft

  @impl true
  def update(%{nft: nft} = assigns, socket) do
    changeset = Nft.changeset(nft)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"nft" => nft_params}, socket) do
    changeset =
      socket.assigns.nft
      |> Nft.changeset(nft_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"nft" => nft_params}, socket) do
    save_nft(socket, socket.assigns.action, nft_params)
  end

  defp save_nft(socket, :edit, nft_params) do
    case Nft.update(socket.assigns.nft, nft_params) do
      {:ok, _nft} ->
        {:noreply,
         socket
         |> put_flash(:info, "Nft updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
