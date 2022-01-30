defmodule TaiShangNftGallery.Chain.Fetcher do
  @moduledoc """
    Fetch Data from Ethereum Type Blockchain.
  """

  alias Utils.TypeTranslator
  alias Ethereumex.HttpClient
  def get_block_number(%{endpoint: endpoint}) do
    {:ok, hex} = HttpClient.eth_block_number(url: endpoint)
    TypeTranslator.hex_to_int(hex)
  end
end
