{
  lib,
  ...
}:
/**
  A function that takes a path of a directory as argument, and returns an attribute set where the keys are the all directories that are that path, and the values are the imported `default.nix` in that subdirectory.

    For example, if the function is called with argument `/some/path`, and at that path `/some/path` is a directory that contains the subdirectories `thing1`, `thing2`, and `thing3`, each containing a `default.nix`, then it returns the following attribute set:
  ```nix
  {
    thing1 = import /some/path/thing1;
    thing2 = import /some/path/thing2;
    thing3 = import /some/path/thing3;
  }
  ```
*/
path:
builtins.mapAttrs (
  entry:
  value:
  import (path + ("/" + entry))
) (
  lib.attrsets.filterAttrs (entry: type: type == "directory") (builtins.readDir path)
)

