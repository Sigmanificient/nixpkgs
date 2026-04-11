/*
  List of active NixOS maintainers.
   ```nix
   handle = {
     # Required
     name = "Your name";
     github = "GithubUsername";
     githubId = your-github-id;

     # Optional
     email = "address@example.org";
     matrix = "@user:example.org";
     keys = [ { fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333"; } ];
   };
   ```

   where

   - `handle` is the handle you are going to use in nixpkgs expressions,
   - `name` is a name that people would know and recognize you by,
   - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
   - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
   - `email` is your maintainer email address,
   - `matrix` is your Matrix user ID,
   - `keys` is a list of your PGP/GPG key fingerprints.

   Specifying a GitHub account is required, because:
   - you will get invited to the @NixOS/nixpkgs-maintainers team;
   - once you are part of the @NixOS org, you can be requested for review;
   - once you can be requested for review, CI will request you review pull requests that modify a package for which you are a maintainer.

   `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.

   If `github` begins with a numeral, `handle` should be prefixed with an underscore.
   ```nix
   _1example = {
     github = "1example";
   };
   ```

   Add PGP/GPG keys only if you actually use them to sign commits and/or mail.

   To get the required PGP/GPG values for a key run
   ```shell
   gpg --fingerprint <email> | head -n 2
   ```

   !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.

   More fields may be added in the future, however, in order to comply with GDPR this file should stay as minimal as possible.

   When editing this file:
    * keep the list alphabetically sorted
    * test the validity of the format with:
        nix-build lib/tests/maintainers.nix

   See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.

   When adding a new maintainer, be aware of the current commit conventions
   documented at [CONTRIBUTING.md](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions)
   file located in the root of the Nixpkgs repo.
*/
let
  lib = import ../lib;
  shards = [
    ./by-name/_.nix
    ./by-name/a.nix
    ./by-name/b.nix
    ./by-name/c.nix
    ./by-name/d.nix
    ./by-name/e.nix
    ./by-name/f.nix
    ./by-name/g.nix
    ./by-name/h.nix
    ./by-name/i.nix
    ./by-name/j.nix
    ./by-name/k.nix
    ./by-name/l.nix
    ./by-name/m.nix
    ./by-name/n.nix
    ./by-name/o.nix
    ./by-name/p.nix
    ./by-name/q.nix
    ./by-name/r.nix
    ./by-name/s.nix
    ./by-name/t.nix
    ./by-name/u.nix
    ./by-name/v.nix
    ./by-name/w.nix
    ./by-name/x.nix
    ./by-name/y.nix
    ./by-name/z.nix
  ];
in
lib.foldr (a: b: a // b) { } (map import shards)
