defmodule TaiShangNftGalleryWeb.AirdropLive.PaidForInput do
  use TaiShangNftGalleryWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <table id="paid_for_input" class="input_container">
        <tbody>
          <tr>
            <td>Addr</td>
            <td>Money</td>
            <td>Unit</td>
            <td/>
          </tr>
          <%= for {paid, index} <- Enum.with_index(@airdrop.paid_for) do %>
            <tr>
              <%= if @editable do %>
              <td>
                <input class="form-control" phx-target={@target} phx-blur="addr_update" phx-value-key={index} id={"airdrop-form_paid_for_addr#{index}"} name={"airdrop[paid_for][#{index}][]"} type="text" value={paid["addr"]}>
              </td>
              <td>
                <input class="form-control" phx-target={@target} phx-blur="money_update" phx-value-key={index} id={"airdrop-form_paid_for_money#{index}"} name={"airdrop[paid_for][#{index}][]"} type="text" value={paid["money"]}>
              </td>
              <td>
                <input class="form-control" phx-target={@target} phx-blur="unit_update" phx-value-key={index} id={"airdrop-form_paid_for_unit#{index}"} name={"airdrop[paid_for][#{index}][]"} type="text" value={paid["unit"]}>
              </td>
              <td>
                <a class="remove-form-field" phx-target={@target} phx-click="remove_paid_for" phx-value-key={index} title="Remove">Remove</a>
              </td>
              <% else %>
              <td>
                <span><%= paid["addr"] %></span>
              </td>
              <td>
                <span><%= paid["money"] %></span>
              </td>
              <td>
                <span><%= paid["unit"] %></span>
              </td>
              <td/>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    """
  end
end
