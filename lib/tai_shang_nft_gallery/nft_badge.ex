defmodule TaiShangNftGallery.NftBadge do
  use Ecto.Schema
  import Ecto.Changeset

  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.{Nft, Badge}
  alias TaiShangNftGallery.NftBadge, as: Ele

  schema "nft_badge" do
    belongs_to :nft, Nft
    belongs_to :badge, Badge
  end


  def get_by_nft_id(nft_id) do
    Repo.all(Ele, nft_id: nft_id)
  end

  def get_all() do
    Repo.all(Ele)
  end
  def create(attrs \\ %{}) do
    %Ele{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def change(%Ele{} = ele, attrs) do
    ele
    |> changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Ele{} = ele) do
    changeset(ele, %{})
  end

  @doc false
  def changeset(%Ele{} = ele, attrs) do
    ele
    |> cast(attrs, [:nft_id, :badge_id])
  end
end