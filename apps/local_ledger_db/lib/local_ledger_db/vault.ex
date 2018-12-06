defmodule LocalLedgerDB.Vault do
  @moduledoc false

  use Cloak.Vault, otp_app: :local_ledger_db

  @impl GenServer
  def init(config) do
    env = Application.get_env(:ewallet, :env)

    config =
      Keyword.put(
        config,
        :ciphers,
        default: {
          Cloak.Ciphers.AES.GCM,
          tag: "AES.GCM.V1", key: secret_key(env)
        }
      )

    {:ok, config}
  end

  defp secret_key(t) when is_binary(t) do
    t
    |> String.to_atom()
    |> secret_key()
  end

  defp secret_key(:prod) do
    "LOCAL_LEDGER_SECRET_KEY"
    |> System.get_env()
    |> Base.decode64!()
  end

  defp secret_key(_) do
    <<81, 98, 218, 231, 73, 11, 210, 156, 118, 252, 177, 144, 224, 97, 197, 156, 196, 13, 183, 9,
      154, 170, 231, 61, 6, 26, 166, 46, 16, 246, 150, 61>>
  end
end
