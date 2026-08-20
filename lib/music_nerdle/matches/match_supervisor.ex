defmodule MusicNerdle.Matches.MatchSupervisor do
  @moduledoc """
  DynamicSupervisor that owns one `MusicNerdle.Matches.MatchServer` per
  active match. `MusicNerdle.Matches.start_match/1` should call
  `DynamicSupervisor.start_child/2` on this.
  """

  use DynamicSupervisor

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
