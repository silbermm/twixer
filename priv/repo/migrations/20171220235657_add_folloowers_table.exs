defmodule Twixir.Repo.Migrations.AddFolloowersTable do
  use Ecto.Migration

  def change do
   create table(:follows, primary_key: false) do
     add :follower_id, references(:users)
     add :followee_id, references(:users)
   end
  end
end
