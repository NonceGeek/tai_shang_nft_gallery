defmodule TaiShangNftGalleryWeb.AirdropLive.FormComponent do
  use TaiShangNftGalleryWeb, :live_component

  alias TaiShangNftGallery.Airdrop
  alias TaiShangNftGallery.Chain

  @impl true
  def update(%{airdrop: airdrop} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, Airdrop.change_airdrop(airdrop))
     |> assign(:chains, Enum.map(Chain.get_all(), fn chain -> {chain.name, chain.id} end))
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

  def handle_event("remove_paid_for", %{"key" => tx_idx}, socket) do
    airdrop = socket.assigns.airdrop
    paid_for = List.delete_at(airdrop.paid_for, String.to_integer(tx_idx))
    airdrop = Map.put(airdrop, :paid_for, paid_for)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  def handle_event("add_paid_for", _, socket) do
    airdrop = socket.assigns.airdrop
    paid_for = Enum.concat(airdrop.paid_for, [%{}])
    airdrop = Map.put(airdrop, :paid_for, paid_for)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  defp on_paid_for_field_update(socket, field, %{"key" => idx, "value" => new_value}) do
    airdrop = socket.assigns.airdrop
    idx = String.to_integer(idx)

    paid_info = Enum.at(airdrop.paid_for, idx)
    paid_for = List.replace_at(airdrop.paid_for, idx, Map.put(paid_info, field, new_value))
    airdrop = Map.put(airdrop, :paid_for, paid_for)

    {:noreply, socket
      |> assign(:airdrop, airdrop)
    }
  end

  def handle_event("addr_update", update_info, socket) do
    on_paid_for_field_update(socket, "addr", update_info)
  end

  def handle_event("money_update", update_info, socket) do
    on_paid_for_field_update(socket, "money", update_info)
  end

  def handle_event("unit_update", update_info, socket) do
    on_paid_for_field_update(socket, "unit", update_info)
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

  defp convert_paid_for(airdrop_params) do
    paid_for = Map.get(airdrop_params, "paid_for")

    paid_for_json = paid_for
    |> Map.keys()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.map(fn idx ->
      [addr, money, unit] = Map.get(paid_for, Integer.to_string(idx))

      %{}
      |> Map.put("addr", addr)
      |> Map.put("money", money)
      |> Map.put("unit", unit)
    end)

    airdrop_params
    |> Map.put("paid_for", paid_for_json)
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
    |> convert_paid_for()
    |> remove_empty_txn_id()
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
