wifiDevice: { config, pkgs, lib, ... }:
let
	network-scan = pkgs.writeShellScript "network-scan" ''
		tmp=$(mktemp)
		res=$(mktemp)
		sudo iw dev ${wifiDevice} scan | grep "SSID:" | sed "s/SSID: //g" | sed "s/\t//g" > $tmp

		IFS=$'\n'
		for i in $(cat $tmp); do
			printf "$i" >> $res
			echo "" >> $res
		done

		sort $res
	'';

	network-connect = pkgs.writeShellScript "network-connect" ''
		file=$(mktemp) &&
		interface=${wifiDevice} &&
		sudo wpa_passphrase "$2" "$3" > $file &&
		echo $file &&
		sudo wpa_supplicant -c $file -i ${wifiDevice}
	'';

	network-restart = pkgs.writeShellScript "network-restart" ''
		sudo ip link set ${wifiDevice} down
		sudo ip link set ${wifiDevice} up
	'';
in let
	network = pkgs.writeShellScriptBin "network" ''
		if [[ $1 = "scan" ]]; then
			${network-scan} "$@"
		elif [[ $1 = "connect" ]]; then
			${network-connect} "$@"
		elif [[ $1 = "restart" ]]; then
			${network-restart} "$@"
		else
			echo "Error: First argument must be either scan, connect or restart."
		fi

	'';
in {
	environment.systemPackages = with pkgs; [
		network
	];

	environment.shellAliases = {
		get-external-ip = "curl 'https://api.ipify.org?format=text'";
		get-internal-ip = "ifconfig ${wifiDevice} | grep -Po 'inet [^ ]+' | grep --color=never -o '[^ ]*$'";
	};
}
