# Makefile: A standard Makefile for hello.c

all:
	echo "making"
	mkdir -p build
	cd build; git clone -b 2.1 --single-branch https://github.com/godotengine/godot || true
	cd build/godot; git reset --hard a524cc92e7cccd012d028d870e4648c59473d04e
	cd build/godot; scons -j `nproc` platform=server use_llvm=yes unix_global_settings=".."
	cd build/godot; scons platform=x11 tools=no target=release_debug bits=64 use_llvm=yes -j `nproc`
	mkdir -p build/templates/
	cp build/godot/bin/godot.x11.opt.debug.64.llvm build/templates/linux_x11_64_release
	build/godot/bin/godot_server.server.tools.64 -export "Linux X11" build/cowsrevenge

install:
	cp cowsrevenge /usr/local/bin/
	cp org.pipoypipagames.cowsrevenge.desktop /usr/share/applications
	cp org.pipoypipagames.cowsrevenge.appdata.xml /usr/share/metainfo/
	cp cowsrevenge_icon.png /usr/share/icons/hicolor/64x64/apps/
