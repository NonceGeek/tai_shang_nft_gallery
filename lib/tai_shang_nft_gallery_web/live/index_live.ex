defmodule TaiShangNftGalleryWeb.IndexLive do
  use TaiShangNftGalleryWeb, :live_view
  alias TaiShangNftGallery.{Badge, Nft, NftContract, Airdrop}

  @default_badge "noncegeeker"
  @render_ways ["laydowncat", "raw"]
  @url "https://faasbyleeduckgo.gigalixirapp.com/api/v1/run?name=NftRender.NType&func_name=handle_svg"

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

    uri_handled
      = handle_uri(nft_selected.uri, socket.assigns.render_way)
    {
      :noreply,
      socket
      |> assign(nft_selected: nft_selected)
      |> assign(uri_handled: uri_handled)
    }
  end

  def handle_event("search", %{"addr" => addr}, socket) do
    payload = Nft.check_owner(addr)
    do_handle_event(payload, addr, socket)

  end

  def handle_event("change_render_way", %{"render_f" => %{"render_way" => render_way}}, socket) do

    uri_handled
      = handle_uri(socket.assigns.nft_selected.uri, render_way)
    {
      :noreply,
      socket
      |> assign(uri_handled: uri_handled)
      |> assign(render_way: render_way)
      |> assign(nft: socket.assigns.nft_selected)
    }
  end

  def handle_event(_key, _value, socket) do
    {:noreply, socket}
  end

  def do_handle_event(payload, _addr, socket) when is_nil(payload) do
    {
      :noreply,
      socket
      |> put_flash(:error, "this addr has not any NFT for the Web3Dev.")
    }
  end

  def do_handle_event(_payload, addr, socket) do
    {
      :noreply,
      socket
      |> redirect(to: Routes.addr_path(socket, :index, %{addr: addr}))
    }
  end



  def init(socket) do
    nft_contract = %{id: id} =
      "Web3Dev"
    |> NftContract.get_by_name()
      |> NftContract.preload()
    hodler_num =
      Nft.count(id)
    nft =
      1
      |> Nft.get_by_token_id_and_nft_contract_id(id)
      |> Nft.preload()
    badge_names =
      Badge.get_all()
      |> Enum.map(&(&1.name))
    badge_info_default =
      @default_badge
      |> Badge.get_by_name()
      |> Badge.preload([:token_id, :owner])
    airdrops =
      Airdrop.list()

    uri_handled =
      handle_uri(nft.uri, List.first(@render_ways))
    socket
    |> assign(nft_selected: nft)
    |> assign(nft_contract: nft_contract)
    |> assign(hodler_num: hodler_num)
    |> assign(badge_names: badge_names)
    |> assign(badges_name_selected: @default_badge)
    |> assign(badge_selected: badge_info_default)
    |> assign(airdrops: airdrops)
    |> assign(uri_handled: uri_handled)
    #---
    |> assign(render_ways: @render_ways)
    |> assign(render_way: List.first(@render_ways))
    |> assign(nft: nft)
  end

  # ---

  def handle_uri(%{"payload" => %{"image" => img}}, "laydowncat") do
    try do
      {:ok, %{"result" => %{"image" => uri_handled}}} =
      ExHttp.post(@url, %{
        params: [img, "https://gallery.noncegeek.com/images/"]
        })
      uri_handled
    rescue
       _ ->
      {:error, "renderer service is down"}
    end
  end
  def handle_uri(%{"img_parsed" => img_parsed}, "raw"), do: img_parsed
end
