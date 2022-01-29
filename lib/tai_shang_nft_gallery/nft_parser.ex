defmodule TaiShangNftGallery.NftParser do
  alias Utils.URIHandler

  @keys [
    :first,
    :second,
    :third,
    :fourth,
    :fifth,
    :sixth
  ]

  def parse_token_uri(payload_raw) do
    %{image: img_raw} =
      payload =
        URIHandler.decode_uri(payload_raw)
    img_parsed =
      URIHandler.decode_uri(img_raw)
    %{payload: payload, img_parsed: img_parsed}
  end

  def get_nums_in_svg(img_parsed) do
    value =
      img_parsed
        |> String.split("class=\"base\">")
        |> Enum.drop(1)
        |> Enum.map(&(String.at(&1,0)))
        |> Enum.reject(&(Integer.parse(&1) == :error))
        |> Enum.map(&(String.to_integer(&1)))
    # value
    @keys
    |> Enum.zip(value)
    |> Enum.into(%{})
  end
end
