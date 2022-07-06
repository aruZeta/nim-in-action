if existsEnv("NIX_SQLITE_PATH"):
  --dynlibOverride:sqlite
  --passL:"$NIX_SQLITE_PATH/libsqlite3.so"
