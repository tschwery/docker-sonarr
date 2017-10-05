#!/bin/sh

handle_signal() {
  PID=$!
  kill -s SIGHUP $PID
}
trap "handle_signal" SIGINT SIGQUIT SIGTERM SIGHUP

$@ &
wait
