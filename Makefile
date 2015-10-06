bot:
	vala "--vapidir=vapi --pkg=libtoxcore --pkg=gio-2.0 --target-glib=2.32 -g -X -fsanitize=address" Bot.vala

# just a demo, temporarily
download_nodes:
	vala "--pkg json-glib-1.0 --pkg libsoup-2.4 -g -X -fsanitize=address" download_nodes.vala

style:
	astyle \
		--style=attach \
		--indent=spaces=4 \
		--indent-namespaces \
		--indent-switches \
		--add-one-line-brackets \
		vapi/libtoxcore.vapi Bot.vala

clean:
	rm .goutputstream-*

run:
	make style && make bot && make clean
