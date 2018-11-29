defmodule ActivityLogger.TestDocument do
  @moduledoc """
  Ecto Schema representing test documents.
  """
  use Ecto.Schema
  use Utils.Types.ExternalID
  use ActivityLogger.ActivityLogging
  import Ecto.{Changeset, Query}
  alias Ecto.{Multi, UUID}

  alias ActivityLogger.TestDocument

  @primary_key {:uuid, UUID, autogenerate: true}

  schema "test_document" do
    external_id(prefix: "tdc_")

    field(:title, :string)
    field(:body, :string)
    field(:secret_data, ActivityLogger.Encrypted.Map, default: %{})

    timestamps()
    activity_logging()
  end

  defp changeset(changeset, attrs) do
    changeset
    |> cast_and_validate_required_for_activity_log(
      attrs,
      [:title, :body, :secret_data],
      [:title]
    )
  end

  @spec insert(map()) :: {:ok, %TestDocument{}} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    %TestDocument{}
    |> changeset(attrs)
    |> insert_record_with_activity_log([])
  end
end
