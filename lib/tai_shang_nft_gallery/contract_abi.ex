defmodule TaiShangNftGallery.ContractABI do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftGallery.ContractABI, as: Ele
  alias TaiShangNftGallery.Repo

  schema "contract_abi" do
    field :abi, {:array, :map}

    timestamps()
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
    |> cast(attrs, [:abi])
  end
end
