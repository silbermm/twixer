defmodule Twixir.Repo.Migrations.CreateUniqueIndexForFolloweeFollower do
  use Ecto.Migration

  def change do
    create index(:follows, [:follower_id, :followee_id], unique: true)
  end
end
