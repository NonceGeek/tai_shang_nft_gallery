defmodule TaiShangNftGallery.Repo.Migrations.UpdateChain do
  use Ecto.Migration

  def change do
    alter table :chain do
      add :syncer_type, :string, default: "explorer_api"
    end
  end
end
