# Default target if none is given
TARGET  ?= c64

PROGRAM  = bouncy-$(TARGET).prg
SOURCES  = src/bouncy.c

CC       = cl65
CFLAGS   = -t $(TARGET) -O -I src
LDFLAGS  = -t $(TARGET) -m bouncy-$(TARGET).map

# Commodore machines you can build with: make c64 / make c16 / ...
MACHINES = c64 c128 c16 plus4 vic20 pet cbm510 cbm610

# VICE binary + extra flags for `make run`
ifeq ($(TARGET),c64)
EMU      = x64sc
EMUFLAGS =
else ifeq ($(TARGET),c128)
EMU      = x128
EMUFLAGS =
else ifeq ($(TARGET),c16)
EMU      = xplus4
EMUFLAGS = -model c16
else ifeq ($(TARGET),plus4)
EMU      = xplus4
EMUFLAGS = -model plus4
else ifeq ($(TARGET),vic20)
EMU      = xvic
EMUFLAGS =
else ifeq ($(TARGET),pet)
EMU      = xpet
EMUFLAGS =
else ifeq ($(TARGET),cbm510)
EMU      = xcbm5x0
EMUFLAGS =
else ifeq ($(TARGET),cbm610)
EMU      = xcbm2
EMUFLAGS =
else
EMU      =
EMUFLAGS =
endif

.PHONY: all clean run help $(MACHINES) $(addprefix run-,$(MACHINES))

all: $(PROGRAM)

$(PROGRAM): $(SOURCES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(SOURCES)

# make c64  /  make c16  /  ...
$(MACHINES):
	$(MAKE) TARGET=$@ all

clean:
	$(RM) bouncy-*.prg bouncy-*.map src/*.o src/*.s src/*.lst

run: $(PROGRAM)
ifeq ($(EMU),)
	$(error No VICE mapping for TARGET=$(TARGET). Start an emulator manually.)
endif
	$(EMU) $(EMUFLAGS) -autostart $(PROGRAM)

# make run-c64  /  make run-c16  /  ...
$(addprefix run-,$(MACHINES)):
	$(MAKE) TARGET=$(patsubst run-%,%,$@) run

help:
	@echo "Build:  make                 # default TARGET=$(TARGET)"
	@echo "        make TARGET=c16"
	@echo "        make c64 | c16 | c128 | plus4 | vic20 | pet"
	@echo "Run:    make run             # uses current/default TARGET"
	@echo "        make run TARGET=c16"
	@echo "        make run-c16"