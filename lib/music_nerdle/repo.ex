defmodule MusicNerdle.Repo do
  use Ecto.Repo,
    otp_app: :music_nerdle,
    adapter: Ecto.Adapters.Postgres
end
