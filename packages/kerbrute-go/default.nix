{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
}: let
  version = "1.0.3";
in
  buildGoModule {
    pname = "kerbrute-go";
    inherit version;

    src = fetchFromGitHub {
      owner = "ropnop";
      repo = "kerbrute";
      rev = "v${version}";
      hash = "sha256-HC7iCu16iGS9/bEXfvRLG9cXns6E+jZvqbIaN9liFB4=";
    };

    vendorHash = "sha256-8/3NyKz0rLo3Js6iwzDUki6K/BrljLkl4K9tNgK59XA=";

    meta = with lib; {
      homepage = "https://github.com/ropnop/kerbrute";
      description = "A tool to quickly bruteforce and enumerate valid Active Directory accounts through Kerberos Pre-Authentication";
      license = licenses.asl20;
      maintainers = with maintainers; [majikguy];
    };
  }
