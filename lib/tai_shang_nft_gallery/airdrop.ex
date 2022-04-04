defmodule TaiShangNftGallery.Airdrop do
  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.Airdrop
  alias TaiShangNftGallery.Chain

  use Ecto.Schema
  import Ecto.{Changeset, Query}
  require Logger

  schema "airdrops" do
    field :description, :string
    field :paid_for, {:array, :map}, default: []
    field :related_link, :string
    field :sum, :integer
    field :tx_ids, {:array, :string}, default: []
    belongs_to :chain, Chain

    timestamps()
  end

  @doc false
  def changeset(airdrop, attrs) do
    airdrop
    |> cast(attrs, [:description, :related_link, :sum, :paid_for, :tx_ids, :chain_id])
    |> validate_required([:description, :related_link, :sum, :paid_for, :tx_ids, :chain_id])
  end

  def list_by_chain_id(chain_id) do
    query = from p in Airdrop, where: p.chain_id == ^chain_id

    Repo.all(query)
  end

  @doc """
  Returns the list of airdrops.

  ## Examples

      iex> list_airdrops()
      [%Airdrop{}, ...]

  """
  def list do
    Repo.all(Airdrop)
    |> Repo.preload(:chain)
  end

  @doc """
  Gets a single airdrop.

  Raises `Ecto.NoResultsError` if the Airdrop does not exist.

  ## Examples

      iex> get_airdrop!(123)
      %Airdrop{}

      iex> get_airdrop!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Airdrop, id) |> Repo.preload(:chain)

  @doc """
  Creates a airdrop.

  ## Examples

      iex> create_airdrop(%{field: value})
      {:ok, %Airdrop{}}

      iex> create_airdrop(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Airdrop{}
    |> Airdrop.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a airdrop.

  ## Examples

      iex> update_airdrop(airdrop, %{field: new_value})
      {:ok, %Airdrop{}}

      iex> update_airdrop(airdrop, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(airdrop_id, attrs) do
    airdrop_id
    |> get!()
    |> Airdrop.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a airdrop.

  ## Examples

      iex> delete_airdrop(airdrop)
      {:ok, %Airdrop{}}

      iex> delete_airdrop(airdrop)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Airdrop{} = airdrop) do
    Repo.delete(airdrop)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking airdrop changes.

  ## Examples

      iex> change_airdrop(airdrop)
      %Ecto.Changeset{data: %Airdrop{}}

  """
  def change_airdrop(%Airdrop{} = airdrop, attrs \\ %{}) do
    Airdrop.changeset(airdrop, attrs)
  end
end
