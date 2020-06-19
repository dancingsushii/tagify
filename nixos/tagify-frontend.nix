{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform }:

stdenv.mkDerivation rec {

  pname = "tagify-frontend";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "872672bba06d238f13c2818f081a44acaca6119e";
    sha256 = "0gif0z7m647g6jgrdim9zvavhcwh4nsp4h9ivlvcv501ma7b8ri1";
  };

  installPhase = ''
    mkdir $out
    cp -R $src/dist $out/dist
  '';

  meta = with stdenv.lib; {
    description = "The frontend to tagify";
    homepage = https://github.com/Luis-Hebendanz/tagify-frontend;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.luis-hebendanz ];
    platforms = platforms.all;
  };
}


