{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "lzbench";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lzbench";
    rev = "v${version}";
    sha256 = "sha256-946AcnD9z60Oihm2pseS8D5j6pGdYeCxmhTLNcW9Mmc=";
  };

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp lzbench $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "In-memory benchmark of open-source LZ77/LZSS/LZMA compressors";
    license = licenses.free;
    platforms = platforms.all;
    mainProgram = "lzbench";
  };
}
