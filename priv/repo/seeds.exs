# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TaiShangNftGallery.Repo.insert!(%TaiShangNftGallery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TaiShangNftGallery.Chain

{:ok, %{id: id}} =
  Chain.create(%{
    name: "Moonbeam",
    endpoint: "https://rpc.api.moonbeam.network"
  })

alias TaiShangNftGallery.NftContract
NftContract.create(%{
  name: "web3dev",
  type: "web3dev",
  addr: "0xb6FC950C4bC9D1e4652CbEDaB748E8Cdcfe5655F",
  chain_id: id
})
