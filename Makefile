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
		Bot.vala

debug: bot
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

install:
	cp -v \
		vapi/libtoxav.deps \
		vapi/libtoxcore.vapi \
		vapi/toxencryptsave.vapi \
		vapi/libtoxav.vapi \
		vapi/toxencryptsave.deps \
		/usr/share/vala/vapi
	cp -v \
		vapi/libtoxav.deps \
		vapi/libtoxcore.vapi \
		vapi/toxencryptsave.vapi \
		vapi/libtoxav.vapi \
		vapi/toxencryptsave.deps \
		/usr/share/vala-0.34/vapi
	cp -v \
		vapi/libtoxav.deps \
		vapi/libtoxcore.vapi \
		vapi/toxencryptsave.vapi \
		vapi/libtoxav.vapi \
		vapi/toxencryptsave.deps \
		/usr/share/vala-0.26/vapi

clean:
	rm *tgz \
		*deb

deb-pkg:
	make clean ; checkinstall --install=no \
		--deldoc=yes \
		--deldesc=yes \
		--delspec=yes \
		--default \
		--pkgname=tox-vapi \
		--pkgversion=0.9 \
		--pakdir=../
