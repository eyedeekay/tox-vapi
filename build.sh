#!/bin/sh
valac \
--vapidir=./src/ \
--pkg toxcore \
./tests/vapi-test.vala \
-X -I. \
--verbose

chmod +x ./tests/Vapi-Test
./tests/Vapi-Test
