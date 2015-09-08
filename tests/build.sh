#!/bin/sh

valac --vapidir=../src/ --pkg toxcore vapi-test.vala --verbose

chmod +x Vapi-Test
./Vapi-Test
