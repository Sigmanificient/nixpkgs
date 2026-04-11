let
  lib = import ../lib;
  baseDir = ./by-name;

  dirs = lib.attrNames (lib.readDir baseDir);
in

lib.listToAttrs (
  lib.flatten (
    lib.map (
      d:
      (lib.map (name: {
        name = lib.removeSuffix ".nix" name;
        value = import "${baseDir}/${d}/${name}";
      }) (lib.attrNames (lib.readDir "${baseDir}/${d}")))
    ) dirs
  )
)
