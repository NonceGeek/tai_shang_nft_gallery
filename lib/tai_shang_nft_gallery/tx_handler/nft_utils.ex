defmodule TaiShangNftGallery.TxHandler.NftUtils do
  alias TaiShangNftGallery.Nft
  alias Utils.TypeTranslator

  require Logger

  def handle_tx(func, _nft_contract, from, _to, _value,
    [_from_bin, to_bin, token_id], _chain) when
    func in ["safeTransferFrom", "transferFrom"] do
    # Change Owner
    to_str = TypeTranslator.bin_to_addr(to_bin)
    Logger.info("Transfer NFT from #{from} to #{to_str}")
    nft = Nft.get_by_token_id(token_id)
    Nft.update(nft, %{token_id: token_id, owner: to_str})
  end
end
