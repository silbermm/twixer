defmodule Twixir.Repo.Migrations.UniqueIndexRetweets do
  use Ecto.Migration

  def change do
    create index(:retweets, [:user_id, :tweet_id], unique: true)
  end
end
