username: { config, pkgs, lib, ... }:
let
	mvi = pkgs.writeShellScriptBin "mvi" ''
		mpv --config-dir=$HOME/.config/mvi $1
	'';
in
{
	environment.systemPackages = with pkgs; [
		mvi
		mpv
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/mvi  - - - -  ${./link}"
	];
}
