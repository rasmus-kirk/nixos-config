username: { config, pkgs, lib, ... }:
{
	services.monero.enable = true;

	environment.systemPackages = with pkgs; [
		monero
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/monero           - ${username} - -  -"
		"L+ /home/${username}/.bitmonero  - -           - -  /data/.state/monero"
	];

	environment.shellAliases = {
		monero = "monero-wallet-cli --wallet-file ~/.bitmonero/user-wallet";
	};
}
