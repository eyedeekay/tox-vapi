bot:
	vala "--vapidir=vapi --pkg=libtoxcore --target-glib=2.32 -g" Bot.vala

style:
	astyle --options=astylerc vapi/libtoxcore.vapi Bot.vala
