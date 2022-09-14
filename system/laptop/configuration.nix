args@{ config, pkgs, lib, ... }:
let
	user = "user";

	colorscheme = {
		bg = "282828";
		fg = "ebdbb2";

		black  = "1d2021";
		white  = "d5c4a1";
		orange = "d65d0e";
		red    = "cc241d";
		green  = "98971a";
		yellow = "d79921";
		blue   = "458588";
		purple = "b16286";
		teal   = "689d6a";

		bright = {
			black  = "928374";
			white  = "fbf1c7";
			orange = "fe8019";
			red    = "fb4934";
			green  = "b8bb26";
			yellow = "fabd2f";
			blue   = "83a598";
			purple = "d3869b";
			teal   = "8ec07c";
		};
	};
in {
	imports = [
		./better-defaults.nix
		./hardware-configuration.nix
		./networking.nix
		./age.nix
		(import ../../scripts user args)
		(import ./tmpfs.nix user args)

		(import ../../modules/desktop/abook user args)
		(import ../../modules/desktop/anki user args)
		(import ../../modules/desktop/calcurse user args)
		(import ../../modules/desktop/deemix user args)
		(import ../../modules/desktop/foot user colorscheme args)
		(import ../../modules/desktop/librewolf user args)
		(import ../../modules/desktop/jellyfin-media-player user args)
		(import ../../modules/desktop/jiten user args)
		(import ../../modules/desktop/keepassxc user args)
		(import ../../modules/desktop/mpv user args)
		(import ../../modules/desktop/mutt user args)
		(import ../../modules/desktop/mvi user args)
		(import ../../modules/desktop/newsboat user args)
		#(import ../../modules/desktop/nheko user args)
		(import ../../modules/desktop/qbittorrent user args)
		(import ../../modules/desktop/ssh user args)
		(import ../../modules/desktop/steam user args)
		(import ../../modules/desktop/sway user colorscheme args)
		#(import ../../modules/desktop/virtualbox user args)
		(import ../../modules/desktop/wine user args)
		(import ../../modules/desktop/xdg-utils user args)
		(import ../../modules/desktop/zathura user colorscheme args)

		(import ../../modules/misc/duplicity user args)
		(import ../../modules/misc/git user args)
		(import ../../modules/misc/kakoune user args)
		(import ../../modules/misc/monero user args)
		(import ../../modules/misc/mullvad args)
		(import ../../modules/misc/nnn user args)
		(import ../../modules/misc/rustup user args)
		(import ../../modules/misc/user-dirs user args)
		(import ../../modules/misc/zsh user colorscheme args)
	];

	boot = {
		kernelPackages = pkgs.linuxPackages_latest;
		cleanTmpDir = true;
		loader = {
			efi.canTouchEfiVariables = true;
			timeout = 1;
			systemd-boot.enable = true;
		};
	};

	services.cron = {
		enable = true;
		systemCronJobs = [
			"@reboot  user  ${pkgs.trash-cli}/bin/trash-empty -f 7"
		];
	};

	nixpkgs.config.allowUnfree = true;

	services.atd.enable = true;
	services.mpd = {
		enable = true;
		musicDirectory = "/data/media/audio/music";
		playlistDirectory = "/data/media/audio/playlists";
		extraConfig = ''
			audio_output {
				type  "alsa"
				name  "alsa"
			}
		'';
	};

	virtualisation.docker = {
		enable = true;
		enableOnBoot = true;
	};

	# Timezone
	time.timeZone = "Europe/Copenhagen";

	# Locale
	#i18n.defaultLocale = "en_US.utf8";

	fonts = {
		fontconfig.defaultFonts = {
			emoji = [ "Twitter Color Emoji" ];
			monospace = [ "DejaVu Sans Mono" "Fira Code" "IPAGothic" ];
			sansSerif = [ "DejaVu Sans Serif" "IPAPGothic" ];
			serif = [ "DejaVu Serif" "IPAPMincho" ];
		};
		fonts = with pkgs; [
			fira-code
			monoid
			dejavu_fonts
			ipafont
			liberation_ttf
			twitter-color-emoji
			source-han-sans-traditional-chinese
			source-han-serif-traditional-chinese
			source-han-sans-korean
			source-han-serif-korean
		];
	};

	# Japanese input
	i18n.inputMethod.enabled = "ibus";
	i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ mozc ];

	environment.sessionVariables = {
		QT_IM_MODULE  = "ibus";
		XMODIFIERS    = "@im=ibus";
		GTK_IM_MODULE = "ibus";
	};

	# Closing lid does nothing
	services.logind.lidSwitch = "ignore";

	# Printing
	services.printing.enable = true;
	#hardware.printers.ensurePrinters = [{
	#	name = "HP-laserjet";
	#	deviceUri = "usb://HP/LaserJet%20P2055d?serial=S166RZC";
	#	model = "drv:///sample.drv/laserjet.ppd HP LaserJet Series PCL 4/5";
	#}];

	# Sound
	sound.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
		jack.enable = true;
	};

	# Screen sharing:
	xdg.portal.wlr.enable = true;
	security.rtkit.enable = true;

	# Bluetooth
	hardware.bluetooth.enable = true;
	services.blueman.enable = true;

	# Define a user account.
	users.mutableUsers = false;
	users.users.user = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "docker"];
		passwordFile = config.age.secrets.user.path;
	};

	# List packages installed in system profile.
	environment.systemPackages = with pkgs; [
		# Programming
		ghc
		# Browsers
		ungoogled-chromium
		# Document handling
		pandoc
		texlive.combined.scheme-full
		# Image Editing
		gimp
		# Compression
		zip
		unar
		unzip
		p7zip
		# Terminal programs
		expect
		tesseract
		imagemagick
		silver-searcher
		fzf
		bubblewrap
		ffmpeg
		htop
		tldr
		trash-cli
		wget
		yt-dlp
	] ++ [
		(pkgs.callPackage "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/pkgs/agenix.nix" {})
	];

	system.stateVersion = "20.09";
}
