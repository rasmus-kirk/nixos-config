username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		xdg-utils
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/mimeapps.list     - - - - ${./link/mimeapps.list}"
		"L+ /home/${username}/.local/share/applications - - - - ${./link/desktop-files}"
	];
}
