username: colorscheme: { config, pkgs, lib, ... }:
let
	config = builtins.toFile "zathurarc" ''
		set selection-clipboard clipboard

		set default-bg "#${colorscheme.bg}" #00
		set default-fg "#${colorscheme.fg}" #01

		set statusbar-fg "#${colorscheme.fg}" #04
		set statusbar-bg "#${colorscheme.black}" #01

		set inputbar-bg "#${colorscheme.bg}" #00
		set inputbar-fg "#${colorscheme.white}" #02

		set notification-bg "#${colorscheme.fg}" #08
		set notification-fg "#${colorscheme.bg}" #00

		set notification-error-bg "#${colorscheme.red}" #08
		set notification-error-fg "#${colorscheme.fg}" #00

		set notification-warning-bg "#${colorscheme.yellow}" #08
		set notification-warning-fg "#${colorscheme.fg}" #00

		set highlight-color "#${colorscheme.bright.yellow}" #0A
		set highlight-active-color "#${colorscheme.bright.green}" #0D

		set recolor-lightcolor "#${colorscheme.bg}"
		set recolor-darkcolor "#${colorscheme.fg}"
		set recolor-reverse-video "true"
		set recolor-keephue "true"

		map f toggle_fullscreen
		map r reload
		map R rotate
		map H navigate previous
		map K zoom out
		map J zoom in
		map L navigate next
		map i recolor
		map <Right> navigate next
		map <Left> navigate previous

		map [fullscreen] f toggle_fullscreen
		map [fullscreen] r reload
		map [fullscreen] R rotate
		map [fullscreen] H navigate -1
		map [fullscreen] K zoom out
		map [fullscreen] J zoom in
		map [fullscreen] L navigate 1
		map [fullscreen] i recolor
		map [fullscreen] <Right> navigate next
		map [fullscreen] <Left> navigate previous
	'';
in {
	environment.systemPackages = with pkgs; [
		zathura
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/zathura/zathurarc  - - - - ${config}"
	];
}

