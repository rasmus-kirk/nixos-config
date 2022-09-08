username: colorscheme: { config, pkgs, lib, ... }:
let config = (import ./config/foot.ini.nix colorscheme);
in {
	environment.systemPackages = with pkgs; [
		foot
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/foot/foot.ini - - - - ${config}"
	];

	environment.variables = rec {
		TERMINAL = "foot";
		TERM = "xterm-256color";
	};
}
