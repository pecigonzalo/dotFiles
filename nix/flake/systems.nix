let
  supportedSystems = [
    "aarch64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];
in
{
  inherit supportedSystems;

  forAllSystems =
    function:
    builtins.listToAttrs (
      map (system: {
        name = system;
        value = function system;
      }) supportedSystems
    );
}
