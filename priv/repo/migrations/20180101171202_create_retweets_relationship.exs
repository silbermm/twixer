defmodule Twixir.Repo.Migrations.CreateRetweetsRelationship do
  use Ecto.Migration

  def change do
    create table(:retweets) do
      add :tweet_id, references(:tweets)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
