username: { config, pkgs, lib, ... }:
let
	python-plus-packages = pkgs.python3.withPackages (python-packages: with python-packages; [ deemix ]);
in {
	environment.systemPackages = with pkgs; [
		python-plus-packages
	];

	systemd.tmpfiles.rules = [
		"d /home/${username}/.config/deemix - ${username} - - -"

		"C /home/${username}/.config/deemix/.arl                 0600 ${username} - - ${./link/.arl}"
		"C /home/${username}/.config/deemix/authCredentials.json 0600 ${username} - - ${./link/.arl}"
		"C /home/${username}/.config/deemix/config.json          0600 ${username} - - ${./link/config.json}"
	];
}
