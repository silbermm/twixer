defmodule :"Elixir.Twixir.Repo.Migrations.CreateTweetTable\n" do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :content, :string, size: 140
      add :user_id, references("users")
      timestamps
    end
  end
end
