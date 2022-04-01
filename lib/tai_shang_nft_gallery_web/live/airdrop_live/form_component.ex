defmodule TaiShangNftGalleryWeb.AirdropLive.FormComponent do
  use TaiShangNftGalleryWeb, :live_component

  alias TaiShangNftGallery.Airdrop
  alias TaiShangNftGallery.Chain

  defp format_json(airdrop, field) do
    val = Map.get(airdrop, field)
    if(val == nil, do: val, else: Jason.Formatter.pretty_print_to_iodata(Jason.encode!(val)))
  end

  defp format_list(airdrop, field) do
    val = Map.get(airdrop, field)
    if(val == nil, do: val, else: Enum.join(val, ","))
  end

  @impl true
  def update(%{airdrop: airdrop} = assigns, socket) do
    changeset = airdrop
      |> Airdrop.change_airdrop()
      |> Ecto.Changeset.put_change(:paid_for, format_json(airdrop, :paid_for))
      |> Ecto.Changeset.put_change(:tx_ids, format_list(airdrop, :tx_ids))

    chains = Chain.get_all()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:chains, Enum.map(chains, fn chain -> {chain.name, chain.id} end))
    }

  end

  @impl true
  def handle_event("validate", %{"airdrop" => airdrop_params}, socket) do
    changeset =
      socket.assigns.airdrop
      |> Airdrop.change_airdrop(airdrop_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"airdrop" => airdrop_params}, socket) do
    save_airdrop(socket, socket.assigns.action, airdrop_params)
  end

  defp convert_json(airdrop_params, field) do
    airdrop_params
    |> Map.put(field, Jason.decode!(Map.get(airdrop_params, field)))
  end

  defp convert_list(airdrop_params, field) do
    airdrop_params
    |> Map.put(field, String.split(Map.get(airdrop_params, field), ","))
  end

  defp convert_before_save(airdrop_params) do
    airdrop_params
    |> convert_json("paid_for")
    |> convert_list("tx_ids")
  end

  defp save_airdrop(socket, :edit, airdrop_params) do
    case Airdrop.update(socket.assigns.airdrop, convert_before_save(airdrop_params)) do
      {:ok, _airdrop} ->
        {:noreply,
         socket
         |> put_flash(:info, "Airdrop updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_airdrop(socket, :new, airdrop_params) do
    case Airdrop.create(convert_before_save(airdrop_params)) do
      {:ok, _airdrop} ->
        {:noreply,
         socket
         |> put_flash(:info, "Airdrop created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
