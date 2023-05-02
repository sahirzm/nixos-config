{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
	name = "doom-emacs";
	src = fetchFromGithub {
		owner = "doomemacs";
		repo = "doomemacs";
		rev = "";
	};

}
