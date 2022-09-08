username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		mpv
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/mpv  - - - -  ${./link}"
	];
}
