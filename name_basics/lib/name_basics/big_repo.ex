defmodule NameBasics.BigRepo do
  use Ecto.Repo, otp_app: :name_basics

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :big_url, System.get_env("BIG_DATABASE_URL"))}
  end
end

