defmodule TaiShangNftGallery.Nft do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftGallery.Nft, as: Ele
  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.NftContract

  schema "nft" do
    field :token_id, :integer
    field :uri, :map
    field :info, :map

    belongs_to :nft_contract, NftContract

    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def preload(ele) do
    Repo.preload(ele, [nft_contract: :chain])
  end

  def get_by_id(id) do
    Repo.get_by(Ele, id: id)
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
    |> cast(attrs, [:token_id, :uri, :info, :nft_contract_id])
  end
end
