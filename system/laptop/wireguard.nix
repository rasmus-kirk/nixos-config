{ config, pkgs, ... }:
{
	networking = {
		wg-quick.interfaces.mullvad = {
			address = [ "10.65.109.117/32" ];
			privateKeyFile = config.age.secrets.wg-mullvad.path;
			peers = [{
				allowedIPs = ["0.0.0.0/0" "::0/0"];
				publicKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
				#endpoint = "193.138.218.83:51820";
			}];
		};
	};
}
