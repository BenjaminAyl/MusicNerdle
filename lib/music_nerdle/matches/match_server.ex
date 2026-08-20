defmodule MusicNerdle.Matches.MatchServer do
  @moduledoc """
  One process per active match, holding a live `MusicNerdle.Engine.Game` as
  its state. Started under `MusicNerdle.Matches.MatchSupervisor` and looked
  up via `MusicNerdle.Matches.Registry` (by match id) — callers should never
  hold onto a raw pid, always look it up by id.

  ## Still to design
    * `start_link/1` args (likely a match id + the players)
    * the calls/casts players' moves come in through
    * what happens on completion: broadcast the result over
      `MusicNerdle.PubSub`, persist a `MusicNerdle.Matches.Match`, then
      presumably stop itself
  """

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    {:ok, opts}
  end
end
