{ config, pkgs, lib, inputs, ... }:
{
	nix = {
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 30d";
		};
		settings = {
			cores = 0;
			trusted-users = [ "root" "@wheel" ];
			allowed-users = [ "root" "@wheel" ];
			auto-optimise-store = true;
		};
		package = pkgs.nixUnstable;
		registry.nixpkgs.flake = inputs.nixpkgs;
		nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
		extraOptions =
			let empty_registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}''; in
			''
				experimental-features = nix-command flakes recursive-nix ca-derivations
				flake-registry = ${empty_registry}
				builders-use-substitutes = true
			'';
	};

	environment.pathsToLink = [ "/" ];
	environment.extraOutputsToInstall = [ "doc" "info" ];
	security.sudo = {
		execWheelOnly = true;
		extraConfig = ''Defaults   lecture = never'';
	};

	boot.initrd.availableKernelModules = [ "amdgpu" "usbhid" "usb_storage" "uas" "aesni_intel" "cryptd" "crypto_simd" ];

	services.earlyoom.enable = true;
	services.earlyoom.freeMemThreshold = 3;

	powerManagement.cpuFreqGovernor = "powersave";

	environment.variables = {
		mesa_glthread = "true";

		TMPDIR = "/tmp";
	};
}
