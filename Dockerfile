FROM elixir:slim as base
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}
ENV MIX_HOME /root/.mix
ENV DEBIAN_NONINTERACTIVE=y

RUN apt-get update
RUN apt-get install -y postgresql-client

FROM base as deps

RUN apt-get install -y libsqlite3-dev build-essential

WORKDIR /app

RUN mix local.rebar --force
RUN mix local.hex --force

ADD mix.exs mix.lock ./
RUN mix deps.get --only-prod

RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile


FROM node:lts-alpine as frontend

WORKDIR /app

COPY --from=deps /app/deps deps/

ADD assets/package.json assets/package-lock.json assets/webpack.config.js assets/.babelrc assets/
ADD assets/js assets/js/
ADD assets/css assets/css/
ADD assets/static assets/static/

WORKDIR /app/assets

RUN npm install
RUN npm run deploy


FROM base as build

WORKDIR /app

COPY --from=deps /root/.mix /root/.mix/
COPY --from=deps /app/mix.exs /app/mix.lock ./
COPY --from=deps /app/_build/${MIX_ENV}/lib ./_build/${MIX_ENV}/lib/
COPY --from=deps /app/deps ./deps/
COPY --from=deps /app/config ./config/
COPY --from=frontend /app/priv/static priv/static/

ADD lib lib
RUN mix compile

COPY config/runtime.exs config/
ADD rel rel
ADD priv/repo priv/repo
RUN mix phx.digest

RUN mix release


FROM base as serve

ENV PORT=80
EXPOSE $PORT

WORKDIR /app
COPY --from=build /app/_build/${MIX_ENV}/rel/requestbox ./

ENV PHX_SERVER=true

ENTRYPOINT ["/app/bin/requestbox"]
CMD ["start"]
