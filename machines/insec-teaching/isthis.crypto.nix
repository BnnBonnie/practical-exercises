{
  stdenv
}:

stdenv.mkDerivation {
  name = "isthis.crypto site";
  src = ./isthis.crypto;
  installPhase = ''
    mkdir $out
    cp -rv $src/* $out
  '';
}
