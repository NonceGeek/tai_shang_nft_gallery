defmodule TaiShangNftGallery.NodeInteractor do
  @moduledoc """
      Interact with node.
  """

  alias Utils.TypeTranslator
  require Logger

  def get_txs_by_contract_addr(
    %{
      endpoint: endpoint,
      name: name
    },
    contract_addr,
    start_block,
    end_block) do
    start_block..end_block
    |> Enum.map(fn height ->
      Logger.info("syncing #{height} of #{name}")
      {:ok, payload} =
        height
        |> TypeTranslator.int_to_hex()
        |> Ethereumex.HttpClient.eth_get_block_by_number(
          true,
          [url: endpoint]
        )
      payload
      |> ExStructTranslator.to_atom_struct()
      |> Map.get(:transactions)
      |> filter_by_contract_addr(String.downcase(contract_addr))

    end)
    |> List.flatten()
  end

  def filter_by_contract_addr(txs, contract_addr) do
    Enum.filter(txs, fn tx ->
      tx.from == contract_addr or tx.to == contract_addr
    end)
  end
end
