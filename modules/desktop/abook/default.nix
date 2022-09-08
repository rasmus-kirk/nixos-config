username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		abook
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/abook                    - ${username} - - -"
		"f  /data/.state/abook/addressbook        - ${username} - - -"

		"L+ /home/${username}/.abook/addressbook  - -           - -  /data/.state/abook/addressbook"
		"L+ /home/${username}/.abook/abookrc      - -           - -  ${./link/abookrc}"
	];
}
