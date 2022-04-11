alias TaiShangNftGallery.Chain
alias TaiShangNftGallery.Nft.Syncer
alias TaiShangNftGallery.Chain.Fetcher

{:ok, %{id: chain_id} = chain} =
  Chain.create(%{
    name: "MeterTestnet",
    endpoint: "https://rpctest.meter.io",
    info: %{
      contract: "https://explorer-warringstakes.meter.io/address/",
      tx: "https://explorer-warringstakes.meter.io/tx/"
    },
    syncer_type: "node_api"
  })

alias TaiShangNftGallery.NftContract


# --- init web3dev nft ---

description =
  "To see all the Voxel Nfts!"

abi =
  "contracts/voxel_nft.abi"
  |> File.read!()
  |> Poison.decode!()

alias TaiShangNftGallery.ContractABI

{:ok, %{id: id}} =
  ContractABI.create(%{abi: abi})
best_block = Fetcher.get_block_number(chain)
{:ok, nft_contract} =
  NftContract.create(%{
    name: "Voxel",
    type: "Classic",
    addr: "0x14564daf31EBc4F4Fd83958d77eac73918dEaF5E",
    description: description,
    last_block: best_block,
    contract_abi_id: id,
    chain_id: chain_id
  })

  Syncer.do_sync(chain, nft_contract, 13555900, 13555910)
