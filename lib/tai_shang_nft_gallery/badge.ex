defmodule TaiShangNftGallery.Badge do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftGallery.Badge, as: Ele
  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.NftBadge

  schema "badge" do
    field :name, :string
    field :description, :string
    has_many :nft_id, NftBadge

    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def preload(ele, key_list) do
    %{nft_id: nft_badges} =
      preload(ele)
    nft_info =
      Enum.map(nft_badges, fn %{nft: nft} ->
        Enum.reduce(key_list, %{}, fn key, acc ->
          Map.put(acc, key, Map.get(nft, key))
        end)
      end)
    Map.put(ele, :nft_info, nft_info)
  end
  def preload(ele) do
    Repo.preload(
      ele,
      [nft_id: :nft])
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
    |> cast(attrs, [:name, :description])
  end
end
