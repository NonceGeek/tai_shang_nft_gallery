defmodule TaiShangNftGallery.ScanInteractor do
  @moduledoc """
      Interact with explorers that have standard APIs of Etherscan.
      See Docs:
      > https://moonbeam.moonscan.io/apis#accounts
  """
  require Logger
  def get_txs_by_contract_addr(
    %{
      info: %{"api_explorer" => api_explorer}
    },
    contract_addr,
    start_block,
    end_block,
    api_key, asc_or_desc \\ :asc) do
    payload =
      "#{api_explorer}api?module=account&action=txlist&address="
      |> Kernel.<>("#{contract_addr}&startblock=")
      |> Kernel.<>("#{start_block}&endblock=#{end_block}&sort=")
      |> Kernel.<>("#{asc_or_desc}&apikey=")
      |> Kernel.<>("#{api_key}")
      ExHttp.get(payload)
  end

  def handle_res(%{"status" => "1", "message" => "OK", "result" => result}) do
    {:ok, result}
  end

  def handle_res(others) do
    Logger.error(inspect(others))
    {:error, inspect(others)}
  end
end
