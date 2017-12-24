defmodule Twixir.Accounts.Guardian do
  @moduledoc false

  use Guardian, otp_app: :twixir
  alias Twixir.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, resource.id}
  end

  def resource_from_claims(claims) do
    user =
      claims["sub"]
      |> Accounts.get_user
    {:ok, user}
  end
end
