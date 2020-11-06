defmodule PhoenixStreamlabsClone.UserManager.Guardian do
  @moduledoc """
  This implementation module encapsulates:

  Token type
  Configuration
  Encoding/Decoding
  Callbacks
  """
  use Guardian, otp_app: :phoenix_streamlabs_clone

  alias PhoenixStreamlabsClone.UserManager

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = UserManager.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
