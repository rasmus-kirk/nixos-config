user: { config, pkgs, lib, ... }:
let
	remove-sudo = pkgs.writeShellScriptBin "remove-sudo" ''
		tmphosts=$(mktemp)
		tmpextra=$(mktemp)
		cat ${./config/extra-hosts} > $tmpextra
		kak -f "s  <ret>xypjgh9liwww." $tmpextra
		cat /etc/hosts $tmpextra ${./config/downloaded-hosts} > $tmphosts
		sudo rm /etc/hosts &&
		sudo mv $tmphosts /etc/hosts &&
		sudo chown root /data/media &&
		sudo chmod 007 /etc/hosts &&
		sudo chown root /etc/hosts &&
		sudo gpasswd -d user wheel &&
		swaymsg exit
	'';
in {
	environment.systemPackages = with pkgs; [
		remove-sudo
	];

	services.cron = {
		enable = true;
		systemCronJobs = [
			"@reboot  root  chown -R ${user} /data/media"
		];
	};
}
