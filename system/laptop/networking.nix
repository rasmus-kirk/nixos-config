{ config, pkgs, ... }:
let
	change-mac = pkgs.writeShellScript "change-mac" ''
		card=$1
		tmp=$(mktemp)
		${pkgs.macchanger}/bin/macchanger "$card" -s | grep -oP "[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[^ ]*" > "$tmp"
		mac1=$(cat "$tmp" | head -n 1)
		mac2=$(cat "$tmp" | tail -n 1)
		if [ "$mac1" = "$mac2" ]; then
			if [ "$(cat /sys/class/net/$card/operstate)" = "up" ]; then
				${pkgs.iproute2}/bin/ip link set "$card" down &&
				${pkgs.macchanger}/bin/macchanger -r "$card"
				${pkgs.iproute2}/bin/ip link set "$card" up
			else
				${pkgs.macchanger}/bin/macchanger -r "$card"
			fi
		fi
	'';
in {
	networking.interfaces.enp0s31f6.useDHCP = true;
	networking.interfaces.wlan0.useDHCP = true;

	networking.hostName = "laptop";
	networking.wireless = {
		enable = true;
		environmentFile = config.age.secrets.wifi.path;
		networks = {
			"ET2021"            = {psk = "@HANNE@";};
			"FINN-PC_Network"   = {psk = "@FINN@";};
			"Kitchen 23.1 5GHz" = {psk = "@KITCHEN@";};
			"Kitchen 23.1"      = {psk = "@KITCHEN@";};
			"kummebanden"       = {psk = "@JAKOB@";};
			"NKB-Network"       = {psk = "@NKB@";};
			"🍆💦🍑"            = {psk = "@WILLIAM@";};
			"🍆💦💩"            = {psk = "@WILLIAM@";};
			"🤜🤰"              = {psk = "@ROOM@";};
			"🤜🤰 but slowly"   = {psk = "@ROOM@";};

			".DSB_Wi-Fi"             = {};
			"FlixBus Wi-Fi"          = {};
			"McDonald’s Gratis WiFi" = {};
			"MAX FREE WIFI"          = {};
			"7-ELEVEN WIFI"          = {};
			"Collegenet"             = {};

			eduroam.auth=''
				key_mgmt=WPA-EAP
				pairwise=CCMP
				group=CCMP TKIP
				eap=PEAP
				identity="@EDUROAM_IDENTITY@"
				password=@EDUROAM_PASS@
				phase2="auth=MSCHAPV2"
				#ca_cert="/data/.state/eduroam/au.pem"
				ca_cert="/data/.state/eduroam/au.pem"
			'';
		};
	};

	networking.firewall.enable = true;

	#systemd.services.macchanger = {
	#	enable = true;
	#	description = "macchanger on wlan0";
	#	wants = [ "network-pre.target" ];
	#	before = [ "network-pre.target" ];
	#	bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
	#	after = [ "sys-subsystem-net-devices-wlan0.device" ];
	#	wantedBy = [ "multi-user.target" ];
	#	serviceConfig = {
	#		Type = "oneshot";
	#		ExecStart = "${change-mac} wlan0";
	#	};
	#};
}


