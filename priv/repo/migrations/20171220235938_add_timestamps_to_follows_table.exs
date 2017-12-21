defmodule Twixir.Repo.Migrations.AddTimestampsToFollowsTable do
  use Ecto.Migration

  def change do
    alter table(:follows) do
      timestamps()
    end
  end
end
