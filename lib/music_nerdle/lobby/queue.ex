defmodule MusicNerdle.Lobby.Queue do
  @moduledoc """
  Holds whoever's currently waiting for a match and is responsible for
  pairing them off. One process for the whole lobby, not one per player.

  On a successful pairing, this is expected to call
  `MusicNerdle.Matches.start_match/1` and then notify both players (likely
  over `MusicNerdle.PubSub`) where to go.

  ## Still to design
    * the public API (e.g. `join/1`, `leave/1`)
    * the pairing strategy (FIFO? skill-based? instant vs a short wait to
      batch players?) — if this grows non-trivial, consider splitting the
      strategy out into its own `MusicNerdle.Lobby.Matchmaker` module that
      `Queue` calls into, so "holding state" and "pairing strategy" aren't
      one blob
  """

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end
end
