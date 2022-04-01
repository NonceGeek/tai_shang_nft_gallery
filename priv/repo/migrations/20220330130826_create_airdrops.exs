defmodule TaiShangNftGallery.Repo.Migrations.CreateAirdrops do
  use Ecto.Migration

  def change do
    create table(:airdrops) do
      add :description, :string
      add :related_link, :string
      add :sum, :integer
      add :paid_for, {:array, :map}
      add :tx_ids, {:array, :string}
      add :chain_id, :integer

      timestamps()
    end
  end
end
