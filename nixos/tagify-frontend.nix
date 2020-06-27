{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform }:

stdenv.mkDerivation rec {

  pname = "tagify-frontend";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "11d2f2b28639a11db4a433b973cb9aed67661a06";
    sha256 = "1h39rls0n2rv52h3abjp3sn1f63dksw5h5i2jrv26kj1jx9kn6gr";
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


