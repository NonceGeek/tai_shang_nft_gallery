defmodule TaiShangNftGalleryWeb.NftLive.InfoInput do
  use TaiShangNftGalleryWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
      <ul>
        <li>
          <label>Block Height</label>
          <span><%= @nft.info["block_height"] %></span>
        </li>
        <li>
          <label>Token Info</label>
          <span><%= @nft.info["token_info"] %></span>
        </li>
        <li>
          <label>Description</label>
          <input class="form-control" phx-target={@target} id="nft-form_info_desc" name="nft[info][description]" type="text" value={@nft.info["description"]}>
        </li>
      </ul>
    """
  end
end
