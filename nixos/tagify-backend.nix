{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform }:

rustPlatform.buildRustPackage rec {

  pname = "tagify-backend";
  version = "0.0.1";


  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "ef730098190c7cbcb82cf3291274f356873e4c50";
    sha256 = "0ss0h5kiirmnc5jkak631cq414xyylzzmih71zd18jiqlsgg8gc8";
  };

  cargoSha256 = "1xkq159cv5prin3z3p72mp8kjv0k7bcqlm1z6vp6n1vxax06avxr";


  meta = with stdenv.lib; {
    description = "The backend to tagify";
    homepage = https://github.com/Luis-Hebendanz/tagify-backend;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.luis-hebendanz ];
    platforms = platforms.all;
  };
}


