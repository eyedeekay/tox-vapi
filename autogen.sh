#!/bin/sh
binary_path = "Bot"

if [ -f "$binary_path" ]
then
  rm "$binary_path"
fi

valac \
--vapidir=vapi/ \
--target-glib 2.32 \
--pkg libtoxcore --pkg glib-2.0 \
Bot.vala \
-o Bot \
--verbose --debug \

if [ -f "$binary_path" ]
then
  echo "-- Building app successfully done."
  chmod +x "$binary_path"
  ./Bot
else
  echo "-- Building app failed."
fi
