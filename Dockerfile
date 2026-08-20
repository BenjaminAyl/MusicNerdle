# syntax=docker/dockerfile:1
#
# Multi-stage build: compile an Elixir release in a full Debian image,
# then run it in a slim image that just has the runtime C libraries.
# Versions below match the local toolchain / mix.exs (elixir "~> 1.17").
# Check what's compatible with your `mix.exs` if you bump these -
# https://hub.docker.com/r/hexpm/elixir/tags

ARG ELIXIR_VERSION=1.17.3
ARG OTP_VERSION=27.1.2
ARG DEBIAN_VERSION=bookworm-20241016-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# ---- Build stage ----
FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y && \
    apt-get install -y build-essential git curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

# Install deps first so this layer is cached unless mix.exs/mix.lock change
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib
COPY assets assets

# Build & digest static assets (tailwind/esbuild), then compile the app
RUN mix assets.deploy
RUN mix compile

# Runtime config is read at boot, not compile time, so it's copied last -
# changing it won't bust the layers above
COPY config/runtime.exs config/

RUN mix release

# ---- Runtime stage ----
FROM ${RUNNER_IMAGE} AS app

RUN apt-get update -y && \
    apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV MIX_ENV=prod
# PHX_SERVER must be set for `bin/music_nerdle start` to boot the endpoint
ENV PHX_SERVER=true

WORKDIR /app
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/music_nerdle ./
COPY --chown=nobody:root --chmod=755 bin/docker-entrypoint.sh /app/bin/docker-entrypoint.sh

USER nobody

EXPOSE 4000

ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]
CMD ["start"]
