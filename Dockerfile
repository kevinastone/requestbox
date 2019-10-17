FROM elixir:alpine

ENV MIX_ENV=docker
ENV PORT=80

EXPOSE 80

RUN apk add --update postgresql-client nodejs npm curl

WORKDIR /app

RUN mix local.rebar
RUN mix local.hex --force

ADD mix.exs mix.lock ./
ADD config ./config
RUN mix deps.get --only-prod
ADD assets/package.json assets/package-lock.json assets/brunch-config.js assets/js assets/css assets/static assets/
RUN cd assets && npm install && node node_modules/brunch/bin/brunch build
ADD lib ./lib
RUN mix compile
ADD priv ./priv
RUN mix phx.digest

CMD mix phx.server
