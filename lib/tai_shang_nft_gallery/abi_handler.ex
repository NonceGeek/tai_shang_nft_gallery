defmodule TaiShangNftGallery.ABIHandler do
  alias Utils.TypeTranslator
  def find_and_decode(abi, input_hex) do
    abi
    |> ABI.parse_specification
    |> ABI.find_and_decode(TypeTranslator.hex_to_bin(input_hex))
  end
end
