defmodule TaiShangNftGallery.NftBadge do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.{Nft, Badge}
  alias TaiShangNftGallery.NftBadge, as: Ele

  schema "nft_badge" do
    belongs_to :nft, Nft
    belongs_to :badge, Badge
  end


  def get_by_nft_id(nft_id) do
    Ele
    |> where([e], e.nft_id == ^nft_id)
    |> Repo.all()
  end


  def delete(ele) do
    Repo.delete!(ele)
  end
  def get_by_nft_id_and_badge_id(nft_id, badge_id) do
    Ele
    |> where([e], e.nft_id == ^nft_id and e.badge_id == ^badge_id)
    |> Repo.one()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def create(%{nft_id: nft_id, badge_id: badge_id} = attrs, :no_repeat) do
    payload =
      get_by_nft_id_and_badge_id(nft_id, badge_id)
    if is_nil(payload) do
      create(attrs)
    else
      {:fail, "nft_badge_pair already exists"}
    end
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
