username: { config, pkgs, lib, ... }:
{
	programs.steam.enable = true;

	systemd.tmpfiles.rules = [
		"d  /data/.state/steam                       - ${username} - -  -"
		"L+ /home/${username}/.local/share/Steam     - -           - -  /data/.state/steam"
	];
}
