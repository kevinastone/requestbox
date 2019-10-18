FROM elixir:alpine

ENV MIX_ENV=prod
ENV PORT=80

EXPOSE 80

RUN apk add --update postgresql-client nodejs npm curl

WORKDIR /app

ENV MIX_HOME /root/.mix
RUN mix local.rebar --force
RUN mix local.hex --force

ADD mix.exs mix.lock ./
ADD config ./config
RUN mix deps.get --only-prod
ADD priv/repo priv/
ADD assets/package.json assets/package-lock.json assets/brunch-config.js assets/
ADD assets/js assets/js/
ADD assets/css assets/css/
ADD assets/static assets/static/
RUN cd assets && npm install && DEBUG='brunch:*' node node_modules/brunch/bin/brunch build --production
RUN mix phx.digest

ADD lib lib
RUN mix compile

CMD mix phx.server
