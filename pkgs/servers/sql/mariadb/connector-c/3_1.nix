{ callPackage, ... }@args:

callPackage ./. (
  args
  // {
    version = "3.1.29";
    hash = "sha256-a3lFQdH28iaLV5fEqBoDFVq88vlG+rCKYaiDOjEkGR8=";

    patches = [ ./patches/fix-boolean-typedef.patch ];
  }
)
