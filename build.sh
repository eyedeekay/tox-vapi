#!/bin/sh
valac \
--vapidir=./src/ \
--pkg toxcore \
./tests/vapi-test.vala \
--verbose

chmod +x ./tests/Vapi-Test
./tests/Vapi-Test
