# RequestBox

[![Build Status](https://travis-ci.org/kevinastone/requestbox.svg?branch=master)](https://travis-ci.org/kevinastone/requestbox)

RequestBox allows you to register endpoints that will record and capture HTTP
requests similar to [RequestBin](http://requestb.in/).  It's useful for
debugging webhooks and other API clients.

You can see it dogfood its own webhooks from Github [here](https://enigmatic-stream-8949.herokuapp.com/p0).


## Installation

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

    git clone https://github.com/kevinastone/requestbox.git
    cd requestbox
    mix deps.get
    npm install
    mix ecto.create && mix ecto.migrate
    mix phoenix.server
    open http://localhost:4000

## Screenshot

![screenshot](https://raw.github.com/kevinastone/requestbox/master/web/static/assets/images/screenshot.png)
