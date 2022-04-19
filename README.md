# TaiShangNftGallery

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

---

## TaiShang DAO NFT Projects

TaiShang DAO NFT Projects are the DAO NFT-based community governance projects composed of three sub-projects: 

TaiShang DAO NFT Protocol, TaiShang DAO NFT Gallery, and TaiShang DAO NFT Manager.

![TaiShang DAO NFT Projects](https://tva1.sinaimg.cn/large/e6c9d24egy1h19oyn25ubj20yg0j0q57.jpg)

### 0x01 TaiShang DAO NFT Protocol

> **Repo:**
>
> https://github.com/WeLightProject/Tai-Shang-NFT-Protocols
>
> **Contract on `Polygon Testnet`:**
>
> https://mumbai.polygonscan.com/address/0xa9674c8c25a22de2a27a3d019f8759774e8e5f08#code
>
> **See in `Opensea Testnet`:**
>
> https://testnets.opensea.io/assets/mumbai/0xa9674c8c25a22de2a27a3d019f8759774e8e5f08/1

<img src="https://tva1.sinaimg.cn/large/e6c9d24egy1h19oyngl68j20em0ekq37.jpg" alt="image-20220414225648262" style="zoom: 50%;" />

TaiShang DAO NFT Protocol is an NFT protocol developed by NonceGeek for community governance. The protocol is inherited from ERC721, and the URI is an on-chain SVG that can be displayed in Opensea.

NFTs will load `Badges` in the form of a List as proof of NFT owners' contributions to the community.

For example: `["noncegeeker", "buidler" * 3, "writer" * 2]`, which means that the NFT Owner is a member of the NonceGeek team and has made 3 code contributions and 2 writing contributions.

Badges can be used as the basis for various types of rewards such as Airdrops. Badges will also be reflected in the "community profile" that will be developed in the future.

### 0x02 TaiShang DAO NFT Gallery

> Repo:
> https://github.com/WeLightProject/tai_shang_nft_gallery
>
> Demo page:
>
> https://gallery.noncegeek.com/

![image-20220414235903422](https://tva1.sinaimg.cn/large/e6c9d24egy1h19oz14l6zj21iv0u0wi6.jpg)

TaiShang DAO NFT Gallery has the following functions:

* Used to display all DAO NFTs, and their Badges
* Show all airdrops for DAO NFT Owner
* Search for NFT Owner and its information based on Addr and other information

### 0x03 TaiShang DAO NFT Manager

> Repo:
> https://github.com/WeLightProject/Tai-Shang-DAO-NFT-Manager
>
> Demo page:
>
> https://welightproject.github.io/Tai-Shang-DAO-NFT-Manager/

![image-20220414235931252](https://tva1.sinaimg.cn/large/e6c9d24egy1h19ozjiifej22650u077k.jpg)

TaiShang DAO NFT Manager has the following functions:

- Contract administrators manage DAO NFTs - add and reduce `Badges`
