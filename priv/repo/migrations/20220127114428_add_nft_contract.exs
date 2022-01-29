defmodule TaiShangNftGallery.Repo.Migrations.AddNftContract do
  use Ecto.Migration

  def change do
    create table :nft_contract do
      add :name, :string
      add :description, :text
      add :addr, :string
      add :type, :string
      add :abi, {:array, :map}
      add :last_sync_index, :integer, default: 0

      add :chain_id, :integer

      timestamps()
    end

    create unique_index(:nft_contract, [:name])
  end
end
