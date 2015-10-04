bot:
	vala "--vapidir=vapi --pkg=libtoxcore --target-glib=2.32 -g -X -fsanitize=address" Bot.vala

style:
	astyle --options=astylerc vapi/libtoxcore.vapi Bot.vala
