# man configuration.nix /duplicity
# https://wiki.archlinux.org/title/Duplicity
# TODO: change knownhosts to extraflag
username: { config, pkgs, lib, ... }:
{
	imports = [
		./modules/duplicity.nix
	];

	services.dup = {
		enable = true;
		frequency = "hourly";
		fullIfOlderThan = "1M";
		root = [ "/data" ];
		cleanup.maxFull = 3;
		secretFile = config.age.secrets.duplicity.path;
		targetUrl = "scp://user@192.168.0.69:6000//data/backup/${config.networking.hostName}";
		extraFlags = [
			''--ssh-options=-i /home/${username}/.ssh/id_rsa''
		];
	};

	programs.ssh.knownHosts."[192.168.0.69]:6000" = {
		publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWhAFYaNfrTn/8ZBFNzC8lqNr/iGm8oRhJ6pulnThqV";
	};
}
