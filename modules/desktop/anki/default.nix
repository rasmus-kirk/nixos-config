username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		anki-bin
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/anki          - ${username} - - -"

		"L+ /home/${username}/.local/share/Anki2  - - - - /data/.state/anki"
	];
}
