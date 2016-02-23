VALAC = valac

PKG = --pkg gtk+-3.0 \
      --pkg gstreamer-1.0

SRC = src/edge_music.vala \
      src/window.vala \
      src/headerbar.vala \
      src/albums_view.vala \
      src/artists_view.vala \
      src/songs_view.vala \
      src/search_entry.vala \
      src/controls.vala \
      src/monitor.vala \
      src/tag_getter.vala \
      src/player.vala \
      src/utils.vala

BIN = edge-music

all:
	$(VALAC) $(PKG) $(SRC) -o $(BIN)

