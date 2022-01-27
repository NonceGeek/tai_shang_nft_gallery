defmodule TaiShangNftGallery.Repo.Migrations.AddChain do
  use Ecto.Migration

  def change do
    create table :chain do
      add :name, :string
      add :endpoint, :string

      timestamps()
    end

    create unique_index(:chain, [:name])

  end
end
