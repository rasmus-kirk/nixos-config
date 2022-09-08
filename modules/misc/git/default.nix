username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		git
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/git  - - - -  ${./link}"
	];
}
