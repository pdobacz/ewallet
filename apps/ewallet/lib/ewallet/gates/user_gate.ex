defmodule EWallet.UserGate do
  @moduledoc """
  Handles the logic for creating and updating a user.
  """
  alias EWallet.EmailValidator
  alias EWalletDB.{AccountUser, User}
  alias EWalletDB.Helpers.InputAttribute

  #
  # User create
  #

  def create(attrs, account) do
    with {:ok, user} <- User.insert(attrs),
         {:ok, _account_user} <- AccountUser.link(account.uuid, user.uuid) do
      {:ok, user}
    else
      error -> error
    end
  end

  #
  # User update
  #

  def update(user, attrs) do
    with email <- InputAttribute.get(attrs, :email),
         {:ok, user} <- update_email(user, email),
         attrs <- strip_email_attr(attrs),
         {:ok, user} <- User.update(user, attrs) do
      {:ok, user}
    else
      error -> error
    end
  end

  # Skips email updating if the email attribute is not provided
  def update_email(user, nil), do: {:ok, user}

  # Skips email updating if the same email address is provided
  def update_email(%{email: email} = user, email), do: {:ok, user}

  def update_email(user, email) do
    with {:ok, email} <- EmailValidator.validate(email),
         {:email_taken, nil} <- {:email_taken, User.get_by(email: email)},
         {:ok, user} <- send_email_update_verification(user, email) do
      {:ok, user}
    else
      {:email_taken, _} ->
        {:error, :email_taken}

      error ->
        error
    end
  end

  defp send_email_update_verification(user, _email) do
    {:ok, user}
  end

  defp strip_email_attr(attrs) do
    attrs
    |> Map.delete(:email)
    |> Map.delete("email")
  end

  #
  # User email update verification
  #

  def verify_email(_user, _attrs) do
    # Checks verification token is valid
    # Checks email is not already used
    # Updates the user's email
    # Delete the verification token
  end

  #
  # User password verification
  #

  def update_password(user, attrs, opts \\ []) do
    User.update_password(user, attrs, opts)
  end

  def store_avatar(user, attrs) do
    User.store_avatar(user, attrs)
  end
end
