username: { config, pkgs, lib, ... }:
{
	virtualisation.virtualbox.host.enable = true;
	users.extraGroups.vboxusers.members = [ "${username}" ];

	systemd.tmpfiles.rules = [
		"d  /data/.state/virtualbox             - ${username} - - -"
		"d /home/${username}/.config/VirtualBox - ${username} - - -"

		"L+ /home/${username}/.virtualbox        - - - - /data/.state/virtualbox/machines"
		"L+ /home/${username}/.config/VirtualBox - - - - /data/.state/virtualbox/config"
	];
}
