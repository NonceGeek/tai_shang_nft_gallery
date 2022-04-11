defmodule TaiShangNftGallery.Nft.Interactor do
  @moduledoc """
    Interactor for Nft
  """
  alias TaiShangNftGallery.Nft.Parser
  alias Utils.TypeTranslator
  @default_param_in_call "latest"
  @func %{
    token_uri: "tokenURI(uint256)",
    token_by_index: "tokenByIndex(uint256)",
    total_supply: "totalSupply()",
    owner_of: "ownerOf(uint256)",
  }

  @spec_func %{
    token_info: "getTokenInfo(uint256)"
  }


  def get_token_info(%{endpoint: endpoint}, contract_addr, token_id) do
    data =
      get_data(
        @spec_func.token_info,
        [token_id]
      )
    {:ok, value} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      }, @default_param_in_call, url: endpoint)
    TypeTranslator.data_to_str(value)
  end
  def get_token_by_index(%{endpoint: endpoint}, contract_addr, index) do
    data =
      get_data(
        @func.token_by_index,
        [index]
      )
    {:ok, value} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      }, @default_param_in_call, url: endpoint)
    TypeTranslator.data_to_int(value)
  end
  def query_owner_of(%{endpoint: endpoint}, contract_addr, token_id) do
    data =
      get_data(
        @func.owner_of,
        [token_id]
      )
    {:ok, value} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      }, @default_param_in_call, url: endpoint)
    TypeTranslator.data_to_addr(value)
  end
  def get_total_supply(%{endpoint: endpoint}, contract_addr) do
    data =
      get_data(
        @func.total_supply,
        []
      )
    {:ok, value} =
      Ethereumex.HttpClient.eth_call(%{
        data: data,
        to: contract_addr
      }, @default_param_in_call, url: endpoint)
    TypeTranslator.data_to_int(value)
  end

  def get_token_uri(%{endpoint: endpoint}, contract_addr, token_id) do
    endpoint
    |> do_get_token_uri(contract_addr, token_id)
    |> Parser.parse_token_uri()
  end

  def get_token_uri(%{endpoint: endpoint}, contract_addr, token_id, :external_link) do
    endpoint
    |> do_get_token_uri(contract_addr, token_id)
    |> Parser.parse_token_uri(:external_link)
  end

  def do_get_token_uri(endpoint, contract_addr, token_id) do
    data =
      get_data(
        @func.token_uri,
        [token_id]
      )

    data
    |> eth_call_repeat(contract_addr, @default_param_in_call, endpoint)
    |> TypeTranslator.data_to_str()
  end

  def eth_call_repeat(data, contract_addr, func_name, endpoint) do
    result =
      Ethereumex.HttpClient.eth_call(%{
      data: data,
      to: contract_addr
      }, func_name, url: endpoint)

    case result do
     {:ok, value} ->
        value
      {:error, :timeout} ->
        Process.sleep(1000) # wait 1 sec
        eth_call_repeat(data, contract_addr, func_name, endpoint)
    end
  end

  # +-------------+
  # | Basic Funcs |
  # +-------------+
  @spec get_data(String.t(), List.t()) :: String.t()
  def get_data(func_str, params) do
    payload =
      func_str
      |> ABI.encode(params)
      |> Base.encode16(case: :lower)

    "0x" <> payload
  end
end
