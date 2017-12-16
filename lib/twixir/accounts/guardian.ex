defmodule Twixir.Accounts.Guardian do
  use Guardian, otp_app: :twixir

  def subject_for_token(resource, _claims) do
    {:ok, resource.id}
  end

  def resource_from_claims(claims) do
    {:ok, %{id: claims["sub"]}}
  end
end
