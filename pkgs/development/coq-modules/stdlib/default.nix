{
  coq,
  rocqPackages,
  mkCoqDerivation,
  lib,
  version ? null,
}@args:
(mkCoqDerivation {

  pname = "stdlib";
  repo = "stdlib";
  owner = "coq";
  opam-name = "coq-stdlib";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      { case = isEq "9.0"; out = "9.0.0"; }
      # the one below is artificial as stdlib was included in Coq before
      { case = isLt "9.0"; out = "9.0.0"; }
    ] null;
  releaseRev = v: "V${v}";

  release."9.0.0".sha256 = "sha256-2l7ak5Q/NbiNvUzIVXOniEneDXouBMNSSVFbD1Pf8cQ=";

  configurePhase = ''
    echo no configuration
  '';
  buildPhase = ''
    echo building nothing
  '';
  installPhase = ''
    runHook preInstall

    echo installing nothing

    runHook postInstall
  '';

  meta = {
    description = "Compatibility metapackage for Coq Stdlib library after the Rocq renaming";
    license = lib.licenses.lgpl21Only;
  };

}).overrideAttrs
  (
    o:
    # stdlib is already included in Coq <= 8.20
    if coq.version != null && coq.version != "dev" && lib.versions.isLt "8.21" coq.version then {
      installPhase = ''
        runHook preInstall

        touch $out

        runHook postInstall
      '';
    } else { propagatedBuildInputs = [ rocqPackages.stdlib ]; }
  )
