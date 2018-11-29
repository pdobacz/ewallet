use Mix.Config

config :ewallet_db,
  ecto_repos: [EWalletDB.Repo],
  env: Mix.env(),
  settings: [
    :base_url,
    :min_password_length,
    :file_storage_adapter,
    :aws_bucket,
    :aws_region,
    :aws_access_key_id,
    :aws_secret_access_key,
    :gcs_bucket,
    :gcs_credentials
  ]

import_config "#{Mix.env()}.exs"

#
# @schemas_to_audit_types %{
#   ActivityLogger.System => "system",
#   EWalletDB.User => "user",
#   EWalletDB.Invite => "invite",
#   EWalletDB.Key => "key",
#   EWalletDB.ForgetPasswordRequest => "forget_password_request",
#   EWalletDB.UpdateEmailRequest => "update_email_request",
#   EWalletDB.AccountUser => "account_user",
#   EWalletDB.Transaction => "transaction",
#   EWalletDB.Mint => "mint",
#   EWalletDB.TransactionRequest => "transaction_request",
#   EWalletDB.TransactionConsumption => "transaction_consumption",
#   EWalletDB.Account => "account",
#   EWalletDB.Category => "category",
#   EWalletDB.ExchangePair => "exchange_pair",
#   EWalletDB.Wallet => "wallet",
#   EWalletDB.Membership => "membership",
#   EWalletDB.AuthToken => "auth_token",
#   EWalletDB.APIKey => "api_key",
#   EWalletDB.Token => "token",
#   EWalletDB.Role => "role"
# }
