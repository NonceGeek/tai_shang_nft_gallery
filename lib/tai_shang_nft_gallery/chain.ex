defmodule TaiShangNftGallery.Chain do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftGallery.Chain, as: Ele
  alias TaiShangNftGallery.Repo

  schema "chain" do
    field :name, :string
    field :endpoint, :string

    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
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
    |> cast(attrs, [:name, :endpoint])
    |> unique_constraint(:name)
  end
end
