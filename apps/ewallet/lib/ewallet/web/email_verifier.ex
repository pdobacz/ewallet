defmodule EWallet.Web.EmailVerifier do
  @moduledoc """
  This module verifies a user's email address.
  """

  def verify_new_email(user, email) do
    with {:ok, invite} <- Invite.generate(user, preload: :user, success_url: success_url),
         {:ok, account} <- Account.fetch_master_account(),
         {:ok, _account_user} <- AccountUser.link(account.uuid, user.uuid) do
      send_email(invite, verification_url, create_email_func)
    else
      {:error, error} ->
        {:error, error}

      {:error, error, description} ->
        {:error, error, description}
    end
  end

  def verify_email_update(user, email)
end
