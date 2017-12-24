defmodule Twixir.Stream.Follows do
  @moduledoc false

  use Ecto.Schema

  @primary_key false
  schema "follows" do
    field :follower_id, :integer
    field :followee_id, :integer
  end
end
