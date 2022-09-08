username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		nheko
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/nheko         - ${username} - - -"
		"d  /data/.state/nheko/share   - ${username} - - -"
		"d  /data/.state/nheko/config  - ${username} - - -"

		"L+ /home/${username}/.local/share/nheko  - - - - /data/.state/nheko/share"
		"L+ /home/${username}/.config/nheko       - - - - /data/.state/nheko/config"
	];
}
