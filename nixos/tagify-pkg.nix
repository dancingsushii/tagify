{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform }:

rustPlatform.buildRustPackage rec {

  pname = "tagify-backend";
  version = "1.0.0";


  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "21cea54bdcd6e3f7f06bc76d71160553d1fa563f";
    sha256 = "0jmpgni2d65k40wj7hx815hvvkwrs33vbdv0i9d0a7cfvfm3y60h";

  };

  cargoSha256 = "0qkx655d161mih172mj2cqirdsfj95xncnfg7h5l82n3rfajynqd";


  meta = with stdenv.lib; {
    description = "The backend to tagify";
    homepage = https://github.com/Luis-Hebendanz/tagify-backend;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.luis-hebendanz ];
    platforms = platforms.all;
  };
}


