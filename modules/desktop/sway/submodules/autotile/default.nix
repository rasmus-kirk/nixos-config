username: { config, pkgs, ... }:
{
	programs.sway.extraPackages = with pkgs; [
		autotiling
	];

	systemd.user.services.autotiling = {
		description = "Autotiling";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.autotiling}/bin/autotiling";
			RestartSec = 1;
			Restart = "always";
		};
	};
}

