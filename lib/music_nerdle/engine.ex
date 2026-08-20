defmodule MusicNerdle.Engine do
  @moduledoc """
  Public API for the pure game rules — connecting two albums through shared
  attributes (artist, producer, label, genre, ...).

  Deliberately has no processes and no I/O: everything under
  `MusicNerdle.Engine.*` should be plain data + functions, so the rules are
  trivial to unit test without booting anything. `MusicNerdle.Matches` is the
  layer that takes this pure logic and makes it live/stateful/networked.

  ## Still to design
    * the public functions this context exposes (e.g. `new_game/2`,
      `propose_connection/3`, `winner/1`)
  """
end
