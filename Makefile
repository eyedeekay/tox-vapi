bot:
	valac --vapidir=vapi --pkg=libtoxcore --thread --target-glib=2.32 -g Bot.vala

style:
	astyle --options=astylerc vapi/libtoxcore.vapi Bot.vala
