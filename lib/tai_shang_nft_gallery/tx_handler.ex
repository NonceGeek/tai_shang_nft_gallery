defmodule TaiShangNftGallery.TxHandler do
  @moduledoc """
      Handle Ethereum Tx.
  """

  alias TaiShangNftGallery.ABIHandler
  alias TaiShangNftGallery.NftContract

  @success_code "0x1"


  def handle_tx(chain, nft_contract,
    %{
      from: from,
      to: to,
      value: value,
      input: input,
      hash: hash,
      txreceipt_status: "1" # handle only successful tx
    }) do

    do_handle_tx(chain, hash, from, to, value, input, nft_contract)
  end

  def handle_tx(%{endpoint: endpoint} = chain, nft_contract,
  %{
    from: from,
    to: to,
    value: value,
    input: input,
    hash: hash
  }) do
    {:ok, %{"status" => status}} =
      Ethereumex.HttpClient.eth_get_transaction_receipt(
      hash,
      url: endpoint
    )

  if status == @success_code do
    do_handle_tx(chain, hash, from, to, value, input, nft_contract)
  else
    :pass
  end

end


  def handle_tx(_chain, _nft_contract, _others), do: :pass

  def do_handle_tx(chain, hash, from, to, value, input, %{type: type} = nft_contract) do
    nft_contract_preloaded =
      NftContract.preload(nft_contract, :deep)
    input_handled =
      nft_contract_preloaded
      |> Map.get(:contract_abi)
      |> Map.get(:abi)
      |> ABIHandler.find_and_decode_func(input)
    # handle transaction by nft type
    "Elixir.TaiShangNftGallery.TxHandler.#{type}"
    |> String.to_atom()
    |> apply(:handle_tx, [chain, hash, nft_contract_preloaded, from, to, value, input_handled])
  end


end
