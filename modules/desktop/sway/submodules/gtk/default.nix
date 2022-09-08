username: { config, pkgs, ... }:
{
	programs.sway.extraPackages = with pkgs; [
		# gtk
		gtk-engine-murrine
		gtk_engines
		gsettings-desktop-schemas
		lxappearance
	];

	environment.sessionVariables = {
		GTK_THEME="Gruvbox-Material-Dark";
	};

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.themes  - - - -  ${./link/themes}"
		"L+ /home/${username}/.icons   - - - -  ${./link/icons}"
	];
}
