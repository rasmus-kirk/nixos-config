username: { config, pkgs, ... }:
let
	config = builtins.toFile "config" ''
		profile dual1 {
			output eDP-1 disable
			output DP-3 mode 1920x1080 position 0,0
			output DP-4 mode 1920x1080 position 1920,0
		}

		profile dual2{
			output eDP-1 disable
			output DP-5 mode 1920x1080 position 0,0
			output DP-6 mode 1920x1080 position 1920,0
		}

		profile {
			output eDP-1 disable
			output DP-3 mode 1920x1080 position 0,0
		}

		profile {
			output eDP-1 disable
			output DP-4 mode 1920x1080 position 0,0
		}

		profile {
			output eDP-1 disable
			output DP-5 mode 1920x1080 position 0,0
		}

		profile {
			output eDP-1 disable
			output DP-6 mode 1920x1080 position 0,0
		}

		profile normal {
			output eDP-1 enable
		}
	'';
in
{
	programs.sway.extraPackages = with pkgs; [
		kanshi
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/kanshi/config  - - - -  ${config}"
	];

	systemd.user.services.kanshi = {
		description = "Kanshi";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.kanshi}/bin/kanshi";
			RestartSec = 1;
			Restart = "always";
		};
	};
}
