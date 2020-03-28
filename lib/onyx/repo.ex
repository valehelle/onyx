defmodule Onyx.Repo do
  use Ecto.Repo,
    otp_app: :onyx,
    adapter: Ecto.Adapters.Postgres
end
