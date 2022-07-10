if existsEnv("NIX_SDL2_PATH"):
  --dynlibOverride:SDL2
  --passL:"$NIX_SDL2_PATH/libSDL2.so"
