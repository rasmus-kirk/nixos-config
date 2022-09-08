username: { config, pkgs, lib, ... }:
{
	boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/5af72121-fc9e-476a-bb7c-6ac27d04bde7";

	environment.etc."systemd/pstore.conf".text = ''
		[PStore]
		Unlink=no
	'';

	systemd.tmpfiles.rules = lib.mkBefore [
		"d  /home/${username}/.local       0755 user users - -"
		"d  /home/${username}/.local/share 0755 user users - -"
		"d  /home/${username}/.config      0755 user users - -"
	];

	fileSystems."/" = {
		fsType = "tmpfs";
		options = [ "noatime" "mode=0755" "size=4G" ];
		neededForBoot = true;
	};

	fileSystems."/root/per" = {
		device = "/dev/disk/by-uuid/ff3fedf8-82a3-435d-ab47-a25e2ebdf5d0";
		fsType = "f2fs";
		options = [ "noatime" "discard" "compress_algorithm=zstd:4" "compress_log_size=5" ];
		neededForBoot = true;
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/3203-DCCF";
		fsType = "vfat";
	};

	fileSystems."/tmp" = {
		device = "/root/per/tmp";
		fsType = "none";
		options = [ "bind" ];
	};

	fileSystems."/nix" = {
		device = "/root/per/nix";
		fsType = "none";
		options = [ "bind" ];
		neededForBoot = true;
	};

	fileSystems."/data" = {
		device = "/root/per/data";
		fsType = "none";
		options = [ "bind" ];
	};

	fileSystems."/var/lib/monero" = {
		device = "/root/per/var/lib/monero";
		fsType = "none";
		options = [ "bind" ];
	};

	fileSystems."/var/lib/duplicity" = {
		device = "/root/per/var/lib/duplicity";
		fsType = "none";
		options = [ "bind" ];
	};

	fileSystems."/var/lib/nixos" = {
		device = "/root/per/var/lib/nixos";
		fsType = "none";
		options = [ "bind" ];
	};
}
