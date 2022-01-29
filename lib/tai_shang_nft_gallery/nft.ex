defmodule TaiShangNftGallery.Nft do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias TaiShangNftGallery.Nft, as: Ele
  alias TaiShangNftGallery.Repo
  alias TaiShangNftGallery.NftContract
  alias TaiShangNftGallery.{NftBadge, Badge}

  schema "nft" do
    field :token_id, :integer
    field :uri, :map
    field :owner, :string
    field :info, :map
    has_many :badge_id, NftBadge
    belongs_to :nft_contract, NftContract

    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def count(nft_contract_id) do
    Ele
    |> where([n], n.nft_contract_id == ^nft_contract_id)
    |> select(count("*"))
    |> Repo.one()
  end

  def get_by_token_id_and_nft_contract_id(token_id, nft_contract_id) do
    Ele
    |> where([n], n.token_id == ^token_id and n.nft_contract_id == ^nft_contract_id)
    |> Repo.one()
  end

  def create_with_no_repeat(
    %{
      token_id: token_id,
      nft_contract_id: nft_contract_id
    } = attrs) do
    payload =
      get_by_token_id_and_nft_contract_id(token_id, nft_contract_id)
    if is_nil(payload) do
      create(attrs)
    else
      {:fail, "token_id already exists"}
    end
  end

  def preload(ele) do
    Repo.preload(ele, [nft_contract: :chain, badge_id: :badge])
  end

  def get_by_id(id) do
    Ele
    |> Repo.get_by(id: id)
    |> preload()
  end

  def get_by_token_id(token_id) do
    Ele
    |> Repo.get_by(token_id: token_id)
    |> preload()
  end

  def create(%{badges: badge_names} = attrs) do
    Repo.transaction(fn ->
      try do
        res =
          %Ele{}
          |> Ele.changeset(attrs)
          |> Repo.insert()
        case res do
          {:error, payload} ->
            # error handler
              Repo.rollback("reason: #{inspect(payload)}")
          {:ok, %{id: id}} ->
            handle_badges(badge_names, id)
        end
      rescue
        error ->
          IO.puts inspect error
          Repo.rollback("reason: #{inspect(error)}")
      end
    end)

  end

  def handle_badges(badge_names, nft_id) do
    Enum.each(badge_names, fn name ->
      %{id: badge_id} = Badge.get_by_name(name)
      NftBadge.create(%{nft_id: nft_id, badge_id: badge_id})
    end)
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
    |> cast(attrs, [:token_id, :uri, :info, :nft_contract_id, :owner])
    |> validate_not_nil([:nft_contract_id])
  end

  def validate_not_nil(changeset, fields) do
    Enum.reduce(fields, changeset, fn field, changeset ->
      if get_field(changeset, field) == nil do
        add_error(changeset, field, "nil")
      else
        changeset
      end
    end)
  end
end
