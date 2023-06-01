{ lib
, vera
, fetchFromGitHub
, python310
, boost
, tcl
}:
vera.overrideAttrs (_: {
  pname = "banana-vera";
  version = "1.3.0-python3.10";

  src = fetchFromGitHub {
    owner = "Epitech";
    repo = "banana-vera";
    rev = "3a7d18d6249cd1790cc63fb9018e0914462ec219";
    sha256 = "sha256-1nAKhUltQS1301JNrr0PQQrrf2W9Hj5gk1nbUhN4cXw=";
  };

  buildInputs = [
    python310
    (boost.override {
      enablePython = true;
      python = python310;
    })
    tcl
  ];

  meta = {
    mainProgram = "vera++";
    description = "A fork of vera using python3.10";
    homepage = "https://github.com/Epitech/banana-vera";
    license = [ lib.licenses.boost ];
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
