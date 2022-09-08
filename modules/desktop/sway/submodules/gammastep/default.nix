username: { config, pkgs, ... }:
let
	config = builtins.toFile "config.ini" ''
		[general]
		adjustment-method=wayland
		brightness-day=1.0
		brightness-night=0.8
		fade=1
		gamma=1
		location-provider=manual
		temp-day=5700
		temp-night=2400

		[manual]
		lat=55.6
		lon=12.5

		[wayland]
		screen=0
	'';
in
{
	programs.sway.extraPackages = with pkgs; [
		gammastep
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/gammastep/config.ini  - - - -  ${config}"
	];

	environment.shellAliases = {
		gammastart = "systemctl --user start gammastep";
		gammastop = "systemctl --user stop gammastep";
	};

	systemd.user.services.gammastep= {
		description = "Gammastep";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.gammastep}/bin/gammastep";
			RestartSec = 1;
			Restart = "always";
		};
	};
}
