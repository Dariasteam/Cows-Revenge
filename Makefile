prefix ?= /usr/local

all:
	echo "making"
	mkdir -p build
	cd build; git clone -b 2.1 --single-branch https://github.com/godotengine/godot || true
	cd build/godot; git reset --hard a524cc92e7cccd012d028d870e4648c59473d04e
	cd build/godot; scons -j `nproc` platform=server use_llvm=yes
	cd build/godot; scons platform=x11 tools=no target=release_debug bits=64 use_llvm=yes -j `nproc`
	mkdir -p ~/.godot/templates/
	cp build/godot/bin/godot.x11.opt.debug.64.llvm ~/.godot/templates/linux_x11_64_release
	build/godot/bin/godot_server.server.tools.64 -export "Linux X11" build/cowsrevenge


install:
	mkdir -p $(prefix)/bin/
	mkdir -p $(prefix)/share/applications/
	mkdir -p $(prefix)/share/metainfo/
	mkdir -p $(prefix)/share/icons/hicolor/64x64/apps/
	mkdir -p $(prefix)/share/icons/hicolor/128x128/apps/
	cp build/cowsrevenge $(prefix)/bin/
	cp linux_build/com.github.dariasteam.cowsrevenge.desktop $(prefix)/share/applications/
	cp linux_build/com.github.dariasteam.cowsrevenge.appdata.xml $(prefix)/share/metainfo/
	cp linux_build/cowsrevenge_icon_64.png $(prefix)/share/icons/hicolor/64x64/apps/com.github.dariasteam.cowsrevenge.png
	cp linux_build/cowsrevenge_icon_128.png $(prefix)/share/icons/hicolor/128x128/apps/com.github.dariasteam.cowsrevenge.png

clean:
	rm -rf build
