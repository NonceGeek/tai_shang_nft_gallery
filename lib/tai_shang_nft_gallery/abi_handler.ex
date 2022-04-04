defmodule TaiShangNftGallery.ABIHandler do
  alias Utils.TypeTranslator
  def find_and_decode_func(abi, input_hex) do
    abi
    |> ABI.parse_specification()
    |> ABI.find_and_decode(TypeTranslator.hex_to_bin(input_hex))
  end

  def find_and_decode_event(abi, topics, data) do
    [topic1, topic2, topic3, topic4] =
      Enum.map(topics, fn topic ->
        TypeTranslator.hex_to_bin(topic)
      end)

    abi
    |> ABI.parse_specification(include_events?: true)
    |> ABI.Event.find_and_decode(topic1, topic2, topic3, topic4, TypeTranslator.hex_to_bin(data))

  end

end
