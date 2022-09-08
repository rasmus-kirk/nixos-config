username: colorscheme: { config, pkgs, ... }:
let
	configRaw = ''
		image=${../../link/wallpapers/ghibli-arrietty.jpg}

		bs-hl-color=${colorscheme.red}
		effect-blur=7x5
		effect-vignette=0.5:0.5
		font=Roboto
		fade-in=3
		grace=3

		inside-color=${colorscheme.bg}99
		key-hl-color=${colorscheme.bright.green}
		bs-hl-color=${colorscheme.red}
		ring-color=${colorscheme.green}
		text-color=${colorscheme.yellow}

		layout-bg-color=${colorscheme.bg}
		layout-border-color=${colorscheme.black}
		layout-text-color=${colorscheme.yellow}

		inside-ver-color=${colorscheme.blue}80
		ring-ver-color=${colorscheme.bright.blue}
		text-ver-color=${colorscheme.fg}

		inside-wrong-color=${colorscheme.red}80
		ring-wrong-color=${colorscheme.bright.red}
		text-wrong-color=${colorscheme.fg}

		inside-clear-color=${colorscheme.yellow}80
		ring-clear-color=${colorscheme.bright.yellow}
		text-clear-color=${colorscheme.fg}
	'';

	config = builtins.toFile "config" (builtins.replaceStrings ["\t"] [""] configRaw);
in
{
	programs.sway.extraPackages = with pkgs; [
		swaylock-effects
		swayidle
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/swaylock/config  - - - -  ${config}"
	];

	systemd.user.services.swayidle = {
		description = "Idle Manager for Wayland";
		documentation = [ "man:swayidle(1)" ];
		wantedBy = [ "sway-session.target" ];
		partOf = [ "graphical-session.target" ];
		path = [ pkgs.bash ];
		serviceConfig = {
			ExecStart = '' ${pkgs.swayidle}/bin/swayidle -w -d \
				timeout 300 '${pkgs.swaylock-effects}/bin/swaylock -C $HOME/.config/swaylock/config'
			'';
			RestartSec = 1;
			Restart = "always";
		};
	};
}
