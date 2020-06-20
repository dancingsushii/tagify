{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform }:

rustPlatform.buildRustPackage rec {

  pname = "tagify-backend";
  version = "0.0.1";


  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "d98a6112b1f803c6de5836c16eec72d952960c45";
    sha256 = "0h1d2jx5vykhhmggx8srkdy1p3z4qpznczkfm5gan292ixk0bv6x";
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


