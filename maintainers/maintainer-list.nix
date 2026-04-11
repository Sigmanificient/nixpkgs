let
  lib = import ../lib;
  baseDir = ./by-name;
in
lib.mergeAttrsList (
  lib.map (name: import "${baseDir}/${name}") (lib.attrNames (lib.readDir baseDir))
)
