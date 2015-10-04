#!/bin/sh
if [ -f "./Bot" ]
then
  rm "./Bot"
fi

if [ "$1" = "--format" ]
then
  echo "-- Formating the code."
  make
  rm *.orig
fi

valac \
--vapidir=vapi/ \
--target-glib 2.32 \
--pkg libtoxcore --pkg glib-2.0 \
--thread \
Bot.vala \
-o Bot \
--verbose --debug \

if [ -f "./Bot" ]
then
  echo "-- Building app successfully done."
  chmod +x Bot
  ./Bot
else
  echo "-- Building app failed."
fi
