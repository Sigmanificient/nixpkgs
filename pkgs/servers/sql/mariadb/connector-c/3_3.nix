{ callPackage, ... }@args:

callPackage ./. (
  args
  // {
    version = "3.3.17";
    hash = "sha256-8DqxI1LLiY65dESoPq8o5gbM96MTtQGCjdVrMsBcGX4=";
  }
)
