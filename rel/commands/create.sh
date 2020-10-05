#!/bin/sh

release_ctl eval --mfa "Requestbox.ReleaseTasks.create/1" --argv -- "$@"
