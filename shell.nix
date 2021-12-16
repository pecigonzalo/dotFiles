
{ pkgs }:
let

in pkgs.mkShell {
  buildInputs = [ pkgs.nixFlakes ];
}
