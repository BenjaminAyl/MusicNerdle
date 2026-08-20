defmodule MusicNerdle.Catalog.Provider do
  @moduledoc """
  Behaviour for an external music metadata source (Spotify Web API,
  MusicBrainz, Discogs, ...). `MusicNerdle.Catalog` should talk to whichever
  provider is configured through this behaviour, so swapping providers (or
  mocking one out in tests) never touches the rest of the app.

  ## Still to design
    * which provider(s) to actually integrate with
    * the callbacks themselves (e.g. `get_album/1`, `search/1`) and the
      shape they return
    * once designed, add the concrete implementation(s) under
      `lib/music_nerdle/catalog/providers/` (e.g. `providers/spotify.ex`)
      implementing this behaviour
  """
end
