defmodule TaiShangNftGallery.NftContract do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftGallery.NftContract, as: Ele
  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.Chain
  alias TaiShangNftGallery.ContractABI
  alias TaiShangNftGallery.Nft

  schema "nft_contract" do
    field :name, :string
    field :description, :string
    field :addr, :string
    field :type, :string
    field :last_block, :integer, default: 0

    belongs_to :chain, Chain
    belongs_to :contract_abi, ContractABI

    has_many :nfts, Nft

    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def preload(ele) do
    Repo.preload(ele, :chain)
  end

  def preload(ele, :deep) do
    Repo.preload(ele, [:chain, :contract_abi])
  end

  def preload(ele, :nfts) do
    Repo.preload(ele, [:nfts])
  end
  def get_by_id(id) do
    Repo.get_by(Ele, id: id)
  end

  def get_by_name(name) do
    Repo.get_by(Ele, name: name)
  end

  def create(attrs \\ %{}) do
    %Ele{}
    |> Ele.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Ele{} = ele, attrs) do
    ele
    |> changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Ele{} = ele) do
    Ele.changeset(ele, %{})
  end

  @doc false
  def changeset(%Ele{} = ele, attrs) do
    ele
    |> cast(attrs, [:name, :description, :addr, :type, :chain_id, :last_block, :contract_abi_id])
    |> unique_constraint(:name)
    |> update_change(:addr, &String.downcase/1)
  end
end
