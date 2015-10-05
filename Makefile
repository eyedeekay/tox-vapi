bot:
	vala "--vapidir=vapi --pkg=libtoxcore --pkg=gio-2.0 --target-glib=2.32 -g -X -fsanitize=address" Bot.vala

style:
	astyle --options=astylerc vapi/libtoxcore.vapi Bot.vala

clean:
	rm .goutputstream-*

run:
	make style && make bot && make clean
