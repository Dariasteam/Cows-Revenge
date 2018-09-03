prefix ?= usr/local
DESTDIR := 
ICONSIZES := 64 128
define \n


endef

build/cowsrevenge: $(wildcard "Scenes/*/*") $(wildcard "Locales/*") $(wildcard "Sound/*") $(wildcard "Music/*") $(wildcard "Sprites/*") $(wildcard "Sprites/*/*") $(wildcard "Fonts/*") $(wildcard "Fonts/*/*") export.cfg engine.cfg d.tscn build/godot/bin/godot_server.server.opt.tools.64
	cd build/godot; scons platform=x11 tools=no target=release bits=`getconf LONG_BIT` use_llvm=yes -j `nproc`
	mkdir -p build/templates/
	cp build/godot/bin/godot.x11*.llvm build/templates/linux_x11_`getconf LONG_BIT`_release
	build/godot/bin/godot_server.server.opt.tools.64 -export "Linux X11" build/cowsrevenge

#build engine
build/godot/bin/godot_server.server.opt.tools.64:
	mkdir -p build
	cd build; git clone -b 2.1 --single-branch https://github.com/godotengine/godot || true
	cd build/godot; scons -j `nproc` platform=server target=release_debug use_llvm=yes unix_global_settings_path=".."

.PHONY: install
install: build/cowsrevenge $(wildcard "linux_build/*")
	install -d "$(DESTDIR)/$(prefix)/bin/"
	install -d "$(DESTDIR)/$(prefix)/share/applications/"
	install -d "$(DESTDIR)/$(prefix)/share/metainfo/"
	install build/cowsrevenge "$(DESTDIR)/$(prefix)/bin/"
	install -m644 linux_build/com.github.dariasteam.cowsrevenge.desktop "$(DESTDIR)/$(prefix)/share/applications/"
	install linux_build/com.github.dariasteam.cowsrevenge.appdata.xml "$(DESTDIR)/$(prefix)/share/metainfo/"
	#install icon files
	$(foreach size,$(ICONSIZES),install -d "$(DESTDIR)/$(prefix)/share/icons/hicolor/$(size)x$(size)/apps/";$(\n))
	$(foreach size,$(ICONSIZES),install -m644 "linux_build/cowsrevenge_icon_$(size).png" "$(DESTDIR)/$(prefix)/share/icons/hicolor/$(size)x$(size)/apps/com.github.dariasteam.cowsrevenge.png";$(\n))
	#update databases if installed to system
	ifeq ($(DESTDIR),)
		-xdg-icon-resource forceupdate --mode system;
		-xdg-desktop-menu forceupdate --mode system;
	endif

.PHONY: uninstall
uninstall: "$(DESTDIR)/$(prefix)/bin/cowsrevenge"
	rm "$(DESTDIR)/$(prefix)/bin/cowsrevenge"
	rm "$(DESTDIR)/$(prefix)/share/applications/linux_build/com.github.dariasteam.cowsrevenge.desktop"
	rm "$(DESTDIR)/$(prefix)/share/metainfo/linux_build/com.github.dariasteam.cowsrevenge.appdata.xml"
	#remove icon files
	$(foreach size,$(ICONSIZES),rm "$(DESTDIR)/$(prefix)/share/icons/hicolor/$(size)x$(size)/apps/com.github.dariasteam.cowsrevenge.png";$(\n))
	#update databases if removed from system
	ifeq ($(DESTDIR),)
		-xdg-icon-resource forceupdate --mode system;
		-xdg-desktop-menu forceupdate --mode system;
	endif

.PHONY: clean
clean:
	rm -rf build
