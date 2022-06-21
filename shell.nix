{ pkgs ? import <nixpkgs> {}
, ...
}:

let
  oldPkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/b4fd657c25f125ab474567b847dfdfc31b5923d1.tar.gz";
    sha256 = "sha256:0vcjcr0yx5mhqf89kfsk2vg1y6xfd2rnbqk654hizv7sckv53pa3";
  }) {};
in pkgs.mkShell {
  buildInputs = with pkgs; [
    oldPkgs.nim
  ];
}
