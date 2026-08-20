defmodule MusicNerdle.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  (which isn't available in releases).

  Invoked from the compiled release, e.g.:

      bin/music_nerdle eval "MusicNerdle.Release.migrate()"

  See `bin/docker-entrypoint.sh` for where this is called from.
  """
  @app :music_nerdle

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
