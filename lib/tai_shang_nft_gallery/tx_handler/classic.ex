defmodule TaiShangNftGallery.TxHandler.Classic do
  alias TaiShangNftGallery.Nft
  alias TaiShangNftGallery.Nft.Interactor
  alias TaiShangNftGallery.TxHandler.NftUtils
  alias TaiShangNftGallery.ChainInteractor

  require Logger

  def handle_tx(chain, hash, nft_contract, from, to, value,
    {%{function: func_name}, data})  do
      do_handle_tx(
        func_name,
        nft_contract, from, to, value, data, hash, chain
      )
  end

  def handle_tx(_chain, _hash, _nft_contract, _from, _to, _value, _others) do
    :pass
  end

  # Util Funcs
  def do_handle_tx(func, nft_contract, from, to, value,
    [from_bin, to_bin, token_id], _hash, chain) when
    func in ["safeTransferFrom", "transferFrom"] do
      NftUtils.handle_tx(func, nft_contract, from, to, value,
        [from_bin, to_bin, token_id], chain)
  end

  def do_handle_tx("mint", %{id: nft_c_id, addr: addr} = nft_contract, from, _to, _value, _params, tx_hash, chain) do
    IO.puts "l"
    token_id = get_token_id(chain, nft_contract, tx_hash)
    uri = Interactor.get_token_uri(chain, addr, token_id, :external_link)
    Nft.create(
      %{
        uri: uri,
        token_id: token_id,
        owner: from,
        nft_contract_id: nft_c_id
    })
  end

  def do_handle_tx(_others, _any, _from, _to, _value, _params, _hash, _chain) do
    :pass
  end

  # -----
  def get_token_id(chain, nft_contract, tx_hash) do
    [{
      _selector, %{"tokenId" => {_, token_id}}
    }] = ChainInteractor.get_tx_receipt(chain, nft_contract, tx_hash)
    token_id
  end
end
