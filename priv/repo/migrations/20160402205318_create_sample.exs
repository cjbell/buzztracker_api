defmodule MosquitoIdentifier.Repo.Migrations.CreateSample do
  use Ecto.Migration

  def change do
    create table(:samples) do
      add :location, :geography
      add :sampled_at, :datetime
      add :reliability, :float
      add :type, :string
      add :species, :string

      timestamps
    end

  end
end
