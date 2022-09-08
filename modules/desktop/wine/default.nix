username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		wine
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/wine        - ${username} - -  -"
		"L+ /home/${username}/.wine  - -           - -  /data/.state/wine"
	];
}
