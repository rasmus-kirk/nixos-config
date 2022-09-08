username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		jellyfin-media-player
	];

	systemd.tmpfiles.rules = [
		''L+ "/home/${username}/.local/share/Jellyfin Media Player" - - - - /data/.state/jellyfin-media-player''
	];
}
