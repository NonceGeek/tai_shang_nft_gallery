defmodule TaiShangNftGalleryWeb.IndexLive do
  use TaiShangNftGalleryWeb, :live_view
  alias TaiShangNftGallery.{Badge, Nft, NftContract}

  @default_badge "noncegeeker"
  @impl true
  def mount(_params, _session, socket) do
    {:ok, init(socket)}
  end

  @impl true
  def handle_event("change_badge", %{
      "f" => %{"badge_name" => badge_name}
    }, socket) do
    badge_info =
      badge_name
      |> Badge.get_by_name()
      |> Badge.preload([:token_id, :owner])
    {
      :noreply,
      socket
      |> assign(badge_selected: badge_info)
    }
  end

  def handle_event("select_nft", %{"token_id" => token_id}, socket) do
    nft_selected =
      token_id
      |> String.to_integer()
      |> Nft.get_by_token_id()
    {
      :noreply,
      socket
      |> assign(nft_selected: nft_selected)
    }
  end

  def handle_event("search", %{"addr" => addr}, socket) do
    payload = Nft.check_owner(addr)
    do_handle_event(payload, socket)

  end

  def handle_event(_key, _value, socket) do
    {:noreply, socket}
  end

  def do_handle_event(payload, socket) when is_nil(payload) do
    {
      :noreply,
      socket
      |> put_flash(:error, "this addr has not any NFT for the Web3Dev.")
    }
  end

  def do_handle_event(%{owner: owner}, socket) do
    {
      :noreply,
      socket
      |> redirect(to: Routes.addr_path(socket, :index, %{addr: owner}))
    }
  end



  def init(socket) do
    nft_contract = %{id: id} =
      "Web3Dev"
    |> NftContract.get_by_name()
      |> NftContract.preload()
    hodler_num =
      Nft.count(id)
    nft = Nft.get_by_id(1)
    badge_names =
      Badge.get_all()
      |> Enum.map(&(&1.name))
    badge_info_default =
      @default_badge
      |> Badge.get_by_name()
      |> Badge.preload([:token_id, :owner])
    socket
    |> assign(nft_selected: nft)
    |> assign(nft_contract: nft_contract)
    |> assign(hodler_num: hodler_num)
    |> assign(badge_names: badge_names)
    |> assign(badges_name_selected: @default_badge)
    |> assign(badge_selected: badge_info_default)
  end
end
