{ pkgs ? import <nixpkgs> {}
, ...
}:

let
  nim-1-6-6-pkgs = (import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/4fc665856d5a6be6f647fd9d63d9390f48763192.tar.gz";
    sha256 = "sha256:1ki0bfbwss244168r1apb3bkjx6w05bmjbpazwgq8298dp2ixx7y";
  }) {});
in pkgs.mkShell {
  buildInputs = with pkgs; [
    nim-1-6-6-pkgs.nim
    pcre
    sqlite
    SDL2
  ];

  shellHook = with pkgs; ''
    export NIX_PCRE_PATH=${pcre.out}/lib
    export NIX_SQLITE_PATH=${sqlite.out}/lib
    export NIX_SDL2_PATH=${SDL2.out}/lib
  '';
}
