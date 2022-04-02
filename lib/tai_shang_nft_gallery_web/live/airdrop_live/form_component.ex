defmodule TaiShangNftGalleryWeb.AirdropLive.FormComponent do
  use TaiShangNftGalleryWeb, :live_component

  alias TaiShangNftGallery.Airdrop
  alias TaiShangNftGallery.Chain

  defp format_json(airdrop, field) do
    val = Map.get(airdrop, field)
    if(val == nil, do: val, else: Jason.Formatter.pretty_print_to_iodata(Jason.encode!(val)))
  end

  @impl true
  def update(%{airdrop: airdrop} = assigns, socket) do
    changeset = airdrop
      |> Airdrop.change_airdrop()
      |> Ecto.Changeset.put_change(:paid_for, format_json(airdrop, :paid_for))

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

  def handle_event("remove_tx_id", %{"key" => tx_idx}, socket) do
    airdrop = socket.assigns.airdrop
    tx_ids = List.delete_at(airdrop.tx_ids, String.to_integer(tx_idx))
    airdrop = Map.put(airdrop, :tx_ids, tx_ids)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  def handle_event("add_tx_id", _, socket) do
    airdrop = socket.assigns.airdrop
    tx_ids = Enum.concat(airdrop.tx_ids, [""])
    airdrop = Map.put(airdrop, :tx_ids, tx_ids)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  def handle_event("tx_update", %{"key" => idx, "value" => new_tx_id}, socket) do
    airdrop = socket.assigns.airdrop
    tx_ids = List.replace_at(airdrop.tx_ids, String.to_integer(idx), new_tx_id)
    airdrop = Map.put(airdrop, :tx_ids, tx_ids)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  defp convert_json(airdrop_params, field) do
    airdrop_params
    |> Map.put(field, Jason.decode!(Map.get(airdrop_params, field)))
  end

  defp remove_empty_txn_id(airdrop_params) do
    data = airdrop_params
      |> Map.get("tx_ids")
      |> Enum.map(fn each ->
        String.trim(each)
      end)
      |> Enum.reject(fn each ->
        each == ""
      end)

    Map.put(airdrop_params, "tx_ids", data)
  end

  defp convert_before_save(airdrop_params) do
    airdrop_params
    |> convert_json("paid_for")
    |> remove_empty_txn_id
  end

  defp save_airdrop(socket, :edit, airdrop_params) do
    case Airdrop.update(socket.assigns.airdrop.id, convert_before_save(airdrop_params)) do
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
