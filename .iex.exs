alias TaiShangNftGallery.{Chain, Nft, NftContract, Badge}
chain = Chain.get_by_id(1)
nft_contract =
  1
  |> NftContract.get_by_id()
  |> NftContract.preload(:deep)

map_nft_contract =
  2
  |> NftContract.get_by_id()
  |> NftContract.preload(:deep)

chain_polygon = Chain.get_by_id(2)

tx_claim_exp =
  %{
    from: "0xfabccb7a695935b5b23a2fee664ff766f31c2d23",
    to: "0xb6fc950c4bc9d1e4652cbedab748e8cdcfe5655f",
    value: "0x0",
    input: "0x379607f50000000000000000000000000000000000000000000000000000000000000001"
  }

tx_set_token_info_exp =
  %{
    from: "0xfabccb7a695935b5b23a2fee664ff766f31c2d23",
    to: "0xb6fc950c4bc9d1e4652cbedab748e8cdcfe5655f",
    value: "0x0",
    input: "0xaba7e0fd00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000f5b226e6f6e63656765656b6572225d0000000000000000000000000000000000"
  }
