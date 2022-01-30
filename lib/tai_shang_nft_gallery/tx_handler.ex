defmodule TaiShangNftGallery.TxHandler do
  @moduledoc """
      Handle Ethereum Tx.
  """

  alias TaiShangNftGallery.ABIHandler
  alias TaiShangNftGallery.NftContract

  def handle_tx(chain, nft_contract, tx) do
    %{
      from: from,
      to: to,
      value: value,
      input: input
    } = tx

    do_handle_tx(chain, from, to, value, input, nft_contract)
  end

  def do_handle_tx(chain, from, to, value, input, %{type: type} = nft_contract) do
    input_handled =
      nft_contract
      |> NftContract.preload(:deep)
      |> Map.get(:contract_abi)
      |> Map.get(:abi)
      |> ABIHandler.find_and_decode(input)

    "Elixir.TaiShangNftGallery.TxHandler.#{type}"
    |> String.to_atom()
    |> apply(:handle_tx, [chain, nft_contract, from, to, value, input_handled])
  end


end
