username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		keepassxc
	];

	systemd.tmpfiles.rules = [
		"d /data/.secret/keepassxc - ${username} - - -"

		"L+ /home/${username}/.config/keepassxc - ${username} - - /data/.state/keepassxc"
	];

	environment.shellAliases = {
		keepassxc = "keepassxc --keyfile /data/.secret/keepassxc/Passwords.kdbx";
	};
}
