defmodule MusicNerdle.AlbumCache do
  @moduledoc """
  Cache-aside store for album lookups, sitting in front of
  `MusicNerdle.Catalog` so repeated lookups for the same album don't have to
  hit the Catalog/Provider (and whatever external API is behind it) every
  time.

  This is the BEAM-native stand-in for "a Redis cache" — an ETS-backed
  process supervised alongside the rest of the app, rather than a separate
  Redis service. Trade-off worth remembering: this cache is per-node and
  clears on every deploy/restart. Fine for one node; revisit (real Redis) if
  this app ever runs on more than one.

  ## Still to design
    * the public API — likely something like `get/1`, `put/3` (with a TTL),
      and a `fetch/2` cache-aside helper that takes a fallback function
    * where the ETS table actually gets created (in `init/1` below) and its
      options (`:set`, `:named_table`, read/write concurrency, ...)
    * eviction/TTL policy — sweep on a timer, or lazy expiry checked on read?
    * cache key shape (album id? provider + external id?)
  """

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(_opts) do
    # TODO: :ets.new/2 the backing table here once the API above is designed.
    {:ok, %{}}
  end
end
