username: args@{ config, pkgs, lib, ... }:
let
	nixos-conf-dir = "/data/.system-configuration";
	wifi-card = "wlan0";
in {
	imports = [
		( import ./nixos-scripts username nixos-conf-dir args )
		( import ./remove-sudo username args )
		( import ./network-scripts wifi-card args )
	];
	
	environment.sessionVariables = {
		PATH = "$PATH:${./bin}";
	};
}

