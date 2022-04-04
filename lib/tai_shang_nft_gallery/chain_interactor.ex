defmodule TaiShangNftGallery.ChainInteractor do
  alias TaiShangNftGallery.ABIHandler
  def get_tx_receipt(%{endpoint: endpoint}, contract, hash) do
    result = Ethereumex.HttpClient.eth_get_transaction_receipt(
      hash,
      url: endpoint
    )
    case result do
      {:ok, nil} ->
        # try again if it's nil
        get_tx_receipt(%{endpoint: endpoint}, contract, hash)
      {:ok, %{"logs" => logs}} ->
        handle_logs(logs, contract)
    end
  end

  def handle_logs(logs, contract) do
    logs
    |> Enum.map(&handle_log(&1, contract))
    |> Enum.reject(&(&1=={:error, :no_matching_function}))
  end

  def handle_log(log, contract) do
    log
    |> ExStructTranslator.to_atom_struct()
    |> do_handle_log(contract)
  end

  # TODO: optimize
  def do_handle_log(%{
    data: data,
    topics: topics
  }, contract) do
    result  =
      ABIHandler.find_and_decode_event(
        contract.contract_abi.abi,
        topics,
        data
      )
    case result do
      {:error, :no_matching_function} ->
        {:error, :no_matching_function}
      {selector, args} ->
        handled_args =
          args
          |> Enum.map(fn {key, type, _, value} ->
            {key, {type, value}}
          end)
          |> Enum.into(%{})
        {selector, handled_args}
    end

  end
end
