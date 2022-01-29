defmodule TaiShangNftGallery.Repo.Migrations.AddBadges do
  use Ecto.Migration

  def change do
    create table :badge do
      add :name, :string
      add :description, :string
      timestamps()
    end

    create unique_index(:badge, [:name])

    create table :nft_badge do
      add :nft_id, :integer
      add :badge_id, :integer
    end
  end
end
