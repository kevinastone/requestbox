#!/bin/sh

release_ctl eval --mfa "Requestbox.ReleaseTasks.migrate/1" --argv -- "$@"
