defmodule ActivityLogger.TestUser do
  @moduledoc """
  Ecto Schema representing test documents.
  """
  use Ecto.Schema
  use Utils.Types.ExternalID
  use ActivityLogger.ActivityLogging
  import Ecto.{Changeset, Query}
  alias Ecto.{Multi, UUID}

  alias ActivityLogger.TestUser

  @primary_key {:uuid, UUID, autogenerate: true}

  schema "test_user" do
    external_id(prefix: "tus_")

    field(:username, :string)

    timestamps()
    activity_logging()
  end

  defp changeset(changeset, attrs) do
    changeset
    |> cast_and_validate_required_for_activity_log(
      attrs,
      [:username],
      [:username]
    )
  end

  @spec insert(map()) :: {:ok, %TestUser{}} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    %TestUser{}
    |> changeset(attrs)
    |> insert_record_with_activity_log([])
  end

  @doc """
  Updates a user with the provided attributes.
  """
  @spec update(%TestUser{}, map()) :: {:ok, %TestUser{}} | {:error, Ecto.Changeset.t()}
  def update(%TestUser{} = user, attrs) do
    user
    |> changeset(attrs)
    |> update_record_with_activity_log()
  end
end
