defmodule MusicNerdle.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MusicNerdleWeb.Telemetry,
      MusicNerdle.Repo,
      {DNSCluster, query: Application.get_env(:music_nerdle, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MusicNerdle.PubSub},
      # Tracks who's actually still connected (lobby presence, in-match
      # disconnect detection) - separate concern from the PubSub broadcasts
      # above, which only say what happened, not who's still here
      MusicNerdleWeb.Presence,
      # Album lookup cache (our BEAM-native "Redis") - sits in front of Catalog
      MusicNerdle.AlbumCache,
      # Registry so a MatchServer's pid can be looked up by match id
      {Registry, keys: :unique, name: MusicNerdle.Matches.Registry},
      # Owns one MatchServer per active match
      MusicNerdle.Matches.MatchSupervisor,
      # Holds whoever's waiting for a match and pairs them off
      MusicNerdle.Lobby.Queue,
      # Start to serve requests, typically the last entry
      MusicNerdleWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MusicNerdle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MusicNerdleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
