FROM elixir:alpine as base
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}
ENV MIX_HOME /root/.mix
RUN apk add --update postgresql-client


FROM base as deps

RUN apk add --update sqlite-dev build-base

WORKDIR /app

RUN mix local.rebar --force
RUN mix local.hex --force

ADD mix.exs mix.lock ./
ADD config ./config
RUN mix deps.get --only-prod
RUN mix deps.compile


FROM node:alpine as frontend

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
COPY --from=deps /app/config ./config/
COPY --from=deps /app/_build/${MIX_ENV}/lib ./_build/${MIX_ENV}/lib/
COPY --from=deps /app/deps ./deps/
COPY --from=frontend /app/priv/static priv/static/

ADD lib lib
ADD rel rel
RUN mix compile

ADD priv/repo priv/repo
RUN mix phx.digest

RUN mix distillery.release --verbose


FROM base as serve

ENV PORT=80
EXPOSE 80

RUN apk update && \
    apk add --no-cache \
      bash

WORKDIR /app
COPY --from=build /app/_build/${MIX_ENV}/rel/requestbox ./

ENTRYPOINT ["/app/bin/requestbox"]
CMD ["foreground"]
