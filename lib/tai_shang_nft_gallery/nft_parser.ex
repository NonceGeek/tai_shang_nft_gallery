defmodule TaiShangNftGallery.NftParser do
  alias Utils.URIHandler
  def parse_token_uri(payload_raw) do
    %{image: img_raw} =
      payload =
        URIHandler.decode_uri(payload_raw)
    img_parsed =
      URIHandler.decode_uri(img_raw)
    %{payload: payload, img_parsed: img_parsed}
  end
end
