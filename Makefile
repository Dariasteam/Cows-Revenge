prefix ?= /usr/local

all:
	mkdir -p build
	cd build; git clone -b 2.1 --single-branch https://github.com/godotengine/godot || true
	cd build/godot; scons -j `nproc` platform=server target=release_debug use_llvm=yes unix_global_settings_path=".."
	cd build/godot; scons platform=x11 tools=no target=release bits=`getconf LONG_BIT` use_llvm=yes -j `nproc`
	mkdir -p build/templates/
	cp build/godot/bin/godot.x11*.llvm build/templates/linux_x11_`getconf LONG_BIT`_release
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
