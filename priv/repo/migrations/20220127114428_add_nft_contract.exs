defmodule TaiShangNftGallery.Repo.Migrations.AddNftContract do
  use Ecto.Migration

  def change do
    create table :nft_contract do
      add :name, :string
      add :description, :text
      add :addr, :string
      add :type, :string
      add :contract_abi_id, :integer
      add :last_block, :integer, default: 0

      add :chain_id, :integer

      timestamps()
    end

    create table :contract_abi do
      add :abi, {:array, :map}
      timestamps()
    end

    create unique_index(:nft_contract, [:name])
  end
end
