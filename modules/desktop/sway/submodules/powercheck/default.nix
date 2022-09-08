username: { config, pkgs, ... }:
let
	powercheck = pkgs.writeShellScript "powercheck" ''
		while :; do
			warn_pct=10
			shutdown_pct=3

			cap=$(cat /sys/class/power_supply/BAT1/capacity)
			status=$(cat /sys/class/power_supply/BAT1/status)

			if [ "$cap" -lt $warn_pct ] && [ ! "$status" == "Charging" ]; then
				echo "Warned_before = $warned"

				if [ -z $warned ]; then
					${pkgs.sway}/bin/swaynag -t warning -m "Battery below $warn_pct%, please plug in a charger immediately. The PC will shut down, saving nothing, when under $shutdown_pct%." &
					warned="True"
				fi
				
				if [ $cap -lt $shutdown_pct ]; then
					shutdown 0
				fi
				
				echo "In loop"
			else
				warned=""
			fi

			echo "Capacity = $cap %"
			echo "Status = $status"
			echo "Warned = $warned"
			sleep 10
		done
	'';
in {
	systemd.user.services.powercheck = {
		description = "Manages battery, by shutting down when it's below 3%";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${powercheck}";
			RestartSec = 1;
			Restart = "always";
		};
	};
}

