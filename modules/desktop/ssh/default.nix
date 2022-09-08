username: { config, pkgs, lib, ... }:
{
	services.sshd.enable = true;
	programs.fuse.userAllowOther = true;

	environment.systemPackages = with pkgs; [
		sshfs
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/ssh        - ${username} - -  -"
		"L+ /home/${username}/.ssh  - -           - -  /data/.state/ssh"
	];
}
