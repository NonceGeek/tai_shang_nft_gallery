defmodule TaiShangNftGalleryWeb.AirdropLive.ListOfStringInput do
  use TaiShangNftGalleryWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <ul id="txn_ids_input" class="input_container">
      <%= for {tx_id, index} <- Enum.with_index(@airdrop.tx_ids) do %>
        <li>
          <%= if @editable do %>
          <input class="form-control" phx-target={@target} phx-blur="tx_update" phx-value-key={index} id={"airdrop-form_tx_ids_#{index}"} name="airdrop[tx_ids][]" type="text" value={tx_id}>
          <a class="remove-form-field" phx-target={@target} phx-click="remove_tx_id" phx-value-key={index} title="Remove">Remove</a>
          <% else %>
          <a href={@airdrop.chain.info["tx"] <> tx_id}><%= tx_id %></a>
          <% end %>
        </li>
      <% end %>
      </ul>
    """
  end
end
