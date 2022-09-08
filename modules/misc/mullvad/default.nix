{ config, pkgs, ... }:
{
	networking = {
		wg-quick.interfaces.mullvad = {
			address = [ "10.65.109.117/32" "fc00:bbbb:bbbb:bb01::2:6d74/128" ];
			privateKeyFile = config.age.secrets.wg-mullvad.path;
			peers = [{
				allowedIPs = ["0.0.0.0/0" "::0/0"];
				publicKey = "fZFAcd8vqWOBpRqlXifsjzGf16gMTg2GuwKyZtkG6UU=";
				endpoint = "193.138.218.83:51820";
			}];
		};
	};

	environment.shellAliases = {
		mullon  = "sudo systemctl start wg-quick-mullvad.service";
		mulloff = "sudo systemctl stop wg-quick-mullvad.service";
	};
}
