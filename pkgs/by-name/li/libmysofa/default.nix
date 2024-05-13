{ lib, stdenv, fetchFromGitHub, cmake, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmysofa";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "hoene";
    repo = "libmysofa";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eXMGwa6lOtKoUCcHR9BM2S3NWAZkGyZzF3FAjYaWTvg=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" "-DCODE_COVERAGE=OFF" ];

  outputs = [ "out" "dev" ];

  meta = {
    description = "Reader for AES SOFA files to get better HRTFs";
    homepage = "https://github.com/hoene/libmysofa";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
