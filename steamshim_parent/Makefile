TARGET			:= steamshim
GAME_LAUNCH_NAME	?= oneshot

CXX			?= clang++
WINDRES			?= windres
HOST			?= linux64
FLAGS			:= -I$(STEAMWORKS)/public -DGAME_LAUNCH_NAME=\"$(GAME_LAUNCH_NAME)\" -Wall

ifeq ($(HOST),w32)
	FLAGS		+= -L$(STEAMWORKS)/redistributable_bin
else ifeq ($(HOST),linux32)
	FLAGS		+= -L$(STEAMWORKS)/redistributable_bin/linux32 -m32
else ifeq ($(HOST),linux64)
	FLAGS		+= -L$(STEAMWORKS)/redistributable_bin/linux64 -m64
else ifeq ($(HOST),osx)
	FLAGS		+= -L$(STEAMWORKS)/redistributable_bin/osx32
endif

FLAGS			+= -lsteam_api

ifeq ($(DEBUG),1)
	FLAGS		+= -DSTEAMSHIM_DEBUG
else
	FLAGS		+= -mwindows
endif

SRC			:= steamshim_parent.cpp
RES			:= resources.rc
RESOBJ			:= resources.o

ifeq ($(HOST),w32)
$(TARGET).exe: $(SRC) $(RESOBJ)
	$(CXX) $^ -o $@ $(FLAGS)
$(RESOBJ): $(RES)
	$(WINDRES) $< $@
else
$(TARGET): $(SRC)
	$(CXX) $^ -o $@ $(FLAGS)
endif

clean:
	rm -f $(TARGET) $(TARGET).exe $(RESOBJ)

.PHONY: clean
