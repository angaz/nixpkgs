{ stdenv, fetchFromGitHub, lib, opam-installer, ocaml, findlib, yojson, opam-file-format, cmdliner }:
stdenv.mkDerivation rec {
  pname = "opam2json";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    sha256 = "fe8bm/V/4r2iNxgbitT2sXBqDHQ0GBSnSUSBg/1aXoI=";
  };

  buildInputs = [ yojson opam-file-format cmdliner ];
  nativeBuildInputs = [ ocaml findlib opam-installer ];

  preInstall = ''export PREFIX="$out"'';

  meta = with lib; {
    platforms = platforms.all;
    description = "convert opam file syntax to JSON";
    maintainers = [ maintainers.balsoft ];
  };
}
