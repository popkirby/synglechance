THIRDPARTY_DIR = thirdparty
PATCHES_DIR = patches

.PHONY: all clean build-ruby build-sound 

all: build-ruby build-sound

build-ruby:
	curl https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.6.tar.gz | tar zx -C $(THIRDPARTY_DIR)
	git apply --directory=$(THIRDPARTY_DIR)/ruby-2.3.6 $(PATCHES_DIR)/ruby/static_zlib.patch
	cd $(THIRDPARTY_DIR)/ruby-2.3.6; ./configure --enable-shared --disable-install-doc --prefix=$(abspath $(THIRDPARTY_DIR))/libs
	make -C $(THIRDPARTY_DIR)/ruby-2.3.6 install

$(THIRDPARTY_DIR)/SDL_sound:
	git clone https://github.com/Ancurio/SDL_sound.git $(THIRDPARTY_DIR)/SDL_sound

build-sound: $(THIRDPARTY_DIR)/SDL_sound
	cd $(THIRDPARTY_DIR)/SDL_sound; ./bootstrap; ./configure --enable-shared --prefix=$(abspath $(THIRDPARTY_DIR))/libs
	make -C $(THIRDPARTY_DIR)/SDL_sound install

clean:
	-rm -rf $(THIRDPARTY_DIR)/ruby-2.3.6
	-rm -rf $(THIRDPARTY_DIR)/SDL_sound
