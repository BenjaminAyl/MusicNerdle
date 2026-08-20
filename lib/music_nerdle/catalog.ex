defmodule MusicNerdle.Catalog do
  @moduledoc """
  Public API for looking up album/artist data. This is the seam between the
  rest of the app and wherever album data actually comes from — other
  contexts should only ever go through here, never call
  `MusicNerdle.AlbumCache` or a `MusicNerdle.Catalog.Provider` directly.

  Expected internal flow (cache-aside): check `MusicNerdle.AlbumCache`
  first, fall back to a configured `MusicNerdle.Catalog.Provider` on a miss,
  populate the cache with the result.

  ## Still to design
    * the public functions (e.g. `get_album/1`, `search_albums/1`)
    * whether album/artist data also gets persisted locally in Postgres
      (for search/autocomplete without hitting the provider every time), or
      this context stays a pure passthrough over Cache + Provider
  """
end
