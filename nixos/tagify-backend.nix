{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, fetchFromGitHub ? pkgs.fetchFromGitHub, rustPlatform ? pkgs.rustPlatform, openssl ? pkgs.openssl, pkg-config ? pkgs.pkg-config }:

rustPlatform.buildRustPackage rec {

  pname = "tagify-backend";
  version = "0.0.1";

  buildInputs = [openssl pkg-config ];

  src = fetchFromGitHub {
    owner = "Luis-Hebendanz";
    repo = pname;
    rev = "7008fa66ca10d7f7ba0ad08f5e90f83f3395bf03";
    sha256 = "1s3csknl0kxcrpcm643lf3aix9xl7vn9g4a1s4zd84vagill3vcd";
  };

  cargoSha256 = "0smm8gr36xx0cjknwwh5xfa2a86339k6wgx184rvz1g2gj28s4vl";


  meta = with stdenv.lib; {
    description = "The backend to tagify";
    homepage = https://github.com/Luis-Hebendanz/tagify-backend;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.luis-hebendanz ];
    platforms = platforms.all;
  };
}


