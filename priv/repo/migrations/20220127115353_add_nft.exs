defmodule TaiShangNftGallery.Repo.Migrations.AddNft do
  use Ecto.Migration

  def change do
    create table :nft do
      add :token_id, :integer
      add :owner, :string
      add :uri, :map
      add :info, :map

      add :nft_contract_id, :integer

      timestamps()
    end
  end
end
