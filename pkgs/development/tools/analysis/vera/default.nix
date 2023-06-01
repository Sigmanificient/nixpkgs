{ lib
, stdenv
, fetchFromBitbucket
, cmake
, python27Full
, boost
, tcl
}:

stdenv.mkDerivation {
  pname = "vera";
  version = "1.3.0";

  src = fetchFromBitbucket {
    owner = "verateam";
    repo = "vera";
    rev = "69f28c5a505294e29a3e95ed0998192fa18b0f08";
    sha256 = "sha256-0vkpa8Adaqfu3/TvZiZqQSzQ4GDLknDh9VYrlY7vD5g=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python27Full
    (boost.override { enablePython = true; python = python27Full; })
    tcl
  ];

  cmakeFlags = [
    "-DVERA_LUA=OFF"
    "-DVERA_USE_SYSTEM_BOOST=ON"
    "-DPANDOC=OFF"
  ];

  meta = {
    mainProgram = "vera++";
    description = "A programmable tool for verification, analysis and transformation of C++ source code";
    license = [ lib.licenses.boost ];
    homepage = "https://github.com/verateam/vera";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
