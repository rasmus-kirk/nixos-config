username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		qbittorrent
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/qbittorrent - ${username} - - -"

		"L+ /home/${username}/.config/qBittorrent - - - - /data/.state/qbittorrent"
	];
}
