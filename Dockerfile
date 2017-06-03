FROM elixir

ENV MIX_ENV=docker PORT=80

EXPOSE 80

# RUN apt-get install -y --no-install-recommends apt-utils \
#   && apt-get install -y curl postgresql-client-9.5 \

RUN apt-get update && apt-get install -y lsb-release
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -c -s)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -

RUN apt-get install -y nodejs postgresql-client

RUN mix local.rebar
RUN mix local.hex --force

WORKDIR /app
ADD mix.exs mix.lock ./
ADD config ./config
RUN mix deps.get --only-prod
ADD package.json brunch-config.js ./
RUN npm install && node node_modules/brunch/bin/brunch build
ADD lib ./lib
ADD web ./web
RUN mix compile
ADD priv ./priv
RUN mix phoenix.digest

CMD ["mix", "run"]
