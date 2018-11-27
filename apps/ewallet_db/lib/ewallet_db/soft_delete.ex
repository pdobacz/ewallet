defmodule EWalletDB.SoftDelete do
  @moduledoc """
  Allows soft delete of Ecto records.

  Requires a `:deleted_at` column with type `:naive_datetime` on the schema.

  The type `:naive_datetime` is used so that it aligns with `Ecto.Migration.timestamps/2`.
  See https://elixirforum.com/t/10129 and https://elixirforum.com/t/9910.

  # Usage

  First, create a new migration that adds `:deleted_at` column:

  ```
  defmodule EWalletDB.Repo.Migrations.AddDeletedAtToSomeSchema do
    use Ecto.Migration

    def change do
      alter table(:some_schema) do
        add :deleted_at, :naive_datetime
      end

      create index(:some_schema, [:deleted_at])
    end
  end
  ```

  Then, implement soft delete in the schema.

  To avoid conflicts with any `delete/1` and/or `restore/1` that may vary between schemas,
  those two functions are not automatically injected with `use`. In order to use them,
  implement your own `delete/1` and `restore/1` that call this module instead.

  ```
  defmodule SomeSchema do
    # ...
    use EWalletDB.SoftDelete

    schema "some_schema" do
      # field :id, ...

      soft_delete()
    end

    def delete(struct), do: SoftDelete.delete(struct)
    def restore(struct), do: SoftDelete.restore(struct)
  end
  ```

  Instead of implementing functions that directly call this module,
  you may use `defdelegate` to delegate the functions to this module:

  ```
  defmodule SomeSchema do
    use EWalletDB.SoftDelete

    # ...

    defdelegate delete(struct), to: SoftDelete
    defdelegate restore(struct), to: SoftDelete
  end
  ```
  """
  use EWalletDB.Auditable
  import Ecto.Query

  @doc false
  defmacro __using__(_) do
    quote do
      # Force `delete/1` and `restore/1` to be imported separately if needed,
      # to avoid confusion with the schema's own  `delete/1` or `restore/1` implementation.
      import EWalletDB.SoftDelete, except: [deleted?: 1, delete: 1, restore: 1]
      alias EWalletDB.SoftDelete
    end
  end

  @doc """
  A macro that adds `:deleted_at` field to a schema.

  Use this on a schema declaration so that it recognizes the soft delete field.
  """
  defmacro soft_delete do
    quote do
      field(:deleted_at, :naive_datetime)
    end
  end

  defp soft_delete_changeset(record, attrs) do
    cast_and_validate_required_for_audit(
      record,
      attrs,
      [:deleted_at]
    )
  end

  @doc """
  Scopes a query down to only records that are not deleted.
  """
  @spec exclude_deleted(Ecto.Queryable.t()) :: Ecto.Queryable.t()
  def exclude_deleted(queryable) do
    where(queryable, [q], is_nil(q.deleted_at))
  end

  @doc """
  Returns whether the given struct is soft-deleted or not.
  """
  @spec deleted?(struct()) :: boolean()
  def deleted?(struct) do
    !is_nil(struct.deleted_at)
  end

  @doc """
  Soft-deletes the given struct.
  """
  @spec delete(struct(), Map.t()) :: any()
  def delete(struct, originator) do
    struct
    |> soft_delete_changeset(%{
      deleted_at: NaiveDateTime.utc_now(),
      originator: originator
    })
    |> update_record_with_audit()
  end

  @doc """
  Restores the given struct from soft-delete.
  """
  @spec restore(struct(), Map.t()) :: any()
  def restore(struct, originator) do
    struct
    |> soft_delete_changeset(%{
      deleted_at: nil,
      originator: originator
    })
    |> update_record_with_audit()
  end
end
