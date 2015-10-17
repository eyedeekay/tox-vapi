bot:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=libsoup-2.4 \
		--pkg=json-glib-1.0 \
		--pkg=libtoxcore \
		--pkg=libtoxav \
		--target-glib=2.32 \
		-g \
		-X -I../../toxcore-new-toxav \
		-X -L../../toxcore-new-toxav/build/.libs \
		Bot.vala
	gdb -ex run ./Bot

style:
	astyle \
		--style=attach \
		--indent=spaces=4 \
		--indent-namespaces \
		--indent-switches \
		--add-one-line-brackets \
		vapi/libtoxcore.vapi \
		vapi/toxav.vapi \
		Bot.vala
