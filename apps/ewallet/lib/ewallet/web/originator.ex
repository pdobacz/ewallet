defmodule EWallet.Web.Originator do
  @moduledoc """
  Module to extract the originator from the conn.assigns.
  """
  alias EWalletDB.{Key, User}

  @spec extract(Map.t()) :: %Key{}
  def extract(%{key: key}) do
    key
  end

  @spec extract(Map.t()) :: %User{}
  def extract(%{admin_user: admin_user}) do
    admin_user
  end

  @spec extract(Map.t()) :: %User{}
  def extract(%{user: user}) do
    user
  end

  @spec set_in_attrs(Map.t(), Map.t()) :: Map.t()
  def set_in_attrs(attrs, originator) do
    Map.put(attrs, "originator", extract(originator))
  end
end
