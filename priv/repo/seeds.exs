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
    endpoint: "https://rpc.api.moonbeam.network",
    info: %{
      contract: "https://moonbeam.moonscan.io/address/"
    }
  })

alias TaiShangNftGallery.NftContract
description =
  "Web3DevNFT has the following uses:\n\n"
  |> Kernel.<>("**0x01)** the Label NFT for Web3Dev@NonceGeek\n\n")
  |> Kernel.<>("**0x02)** one of the Character for TaiShangVerse@NonceGeek")
NftContract.create(%{
  name: "web3dev",
  type: "web3dev",
  addr: "0xb6FC950C4bC9D1e4652CbEDaB748E8Cdcfe5655F",
  description: description,
  chain_id: id
})

alias TaiShangNftGallery.Badge

Badge.create(
  %{
    name: "learner",
    description: "who has finish lessons related by Web3Dev."
  }
)

Badge.create(
  %{
    name: "buidler",
    description: "who buidler things for repos related by Web3Dev."
  }
)

Badge.create(
  %{
    name: "partner",
    description: "partner of Web3Dev."
  }
)

Badge.create(
  %{
    name: "noncegeeker",
    description: "core member of Web3Dev."
  }
)

Badge.create(
  %{
    name: "workshoper",
    description: "who participated in Web3DevWorkshop."
  }
)

Badge.create(
  %{
    name: "camper",
    description: "who participated in Web3DevCamp."
  }
)

Badge.create(
  %{
    name: "writer",
    description: "who created articles in Web3DevCamp."
  }
)
