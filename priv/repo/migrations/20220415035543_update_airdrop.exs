defmodule TaiShangNftGallery.Repo.Migrations.UpdateAirdrop do
  use Ecto.Migration

  def change do
    alter table(:airdrops) do
      modify :sum, :float
    end
  end
end
