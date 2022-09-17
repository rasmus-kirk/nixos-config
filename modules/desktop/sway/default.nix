username: colorscheme: args@{ config, pkgs, lib, ... }:
let
	term = "foot";
	menu = "wofi --show run";

	screenshot = pkgs.writeShellScript "screenshot" ''
		this_display=$(swaymsg -t get_outputs | jq -r ".[] | select(.focused) | .name")
		pictures_dir=$(xdg-user-dir PICTURES)
		date=$(date +"%Y-%m-%d_%T")

		mkdir -p "$pictures_dir"/screenshots &&
		grim -o "$this_display" "$pictures_dir"/screenshots/"$date".png &&
		wl-copy < "$pictures_dir"/screenshots/"$date".png &&
		mpv --no-config ${./link/camera.ogg}
	'';

	screenshot-area = pkgs.writeShellScript "screenshot-area" ''
		date=$(date +"%Y-%m-%d_%T")
		pictures_dir=$(xdg-user-dir PICTURES)

		mkdir -p "$pictures_dir"/screenshots &&
		grim -g "$(slurp)" "$pictures_dir"/screenshots/"$date".png &&
		wl-copy < "$pictures_dir"/screenshots/"$date".png &&
		mpv --no-config ${./link/camera.ogg}
	'';

	set-volume = pkgs.writeShellScript "change-volume" ''
		let new_val=$1+$(pamixer --get-volume)
		if [[ $new_val -le 100 ]]; then
			pactl set-sink-volume @DEFAULT_SINK@ ""$1"%"
		fi
	'';

	startup-volume = pkgs.writeShellScript "startup-volume" ''
		sleep 3
		pactl set-source-volume @DEFAULT_SOURCE@ 17%
		pactl set-sink-volume @DEFAULT_SINK@ 50%
	'';

	toggle-gammastep = pkgs.writeShellScript "toggle-gammastep" ''
		running=$(systemctl status --user gammastep.service | grep Active | grep running)
		if [[ "$running" = "" ]]; then
			systemctl --user start gammastep.service
		else
			systemctl --user stop gammastep.service
		fi
	'';

	sway-config = pkgs.writeText "config" ''
		### Variables
			set $mod Mod4
			set $left h
			set $down j
			set $up k
			set $right l

		### Startup programs
			exec ${term} --app-id=popterm --title=popterm sh -c "cd /data; zsh"
			exec keepassxc --keyfile "" /data/.secret/keepassxc/Passwords.kdbx

			for_window [app_id="popterm"] {
				move scratchpad,
				resize set 1440 810
				#bindsym $mod+q echo "null"
			}

			for_window [title="KeePassXC"] {
				move scratchpad,
				resize set 1440 810
			}

			for_window [app_id="org.jellyfin.jellyfinmediaplayer"] inhibit_idle visible

		### Fonts
			font pango:monospace 12

		### Output configuration
			output * bg ${./link/wallpapers/ghibli-arrietty.jpg} fill
			output DP-3  bg ${./link/wallpapers/ghibli-2-monitors-cut-1.jpg} fill
			output DP-4  bg ${./link/wallpapers/ghibli-2-monitors-cut-2.jpg} fill
			output DP-5  bg ${./link/wallpapers/ghibli-2-monitors-cut-1.jpg} fill
			output DP-6  bg ${./link/wallpapers/ghibli-2-monitors-cut-2.jpg} fill

			workspace 1  output DP-3
			workspace 2  output DP-3
			workspace 3  output DP-3
			workspace 4  output DP-3
			workspace 5  output DP-3
			workspace 6  output DP-4
			workspace 7  output DP-4
			workspace 8  output DP-4
			workspace 9  output DP-4
			workspace 10 output DP-4

			workspace 1  output DP-5
			workspace 2  output DP-5
			workspace 3  output DP-5
			workspace 4  output DP-5
			workspace 5  output DP-5
			workspace 6  output DP-6
			workspace 7  output DP-6
			workspace 8  output DP-6
			workspace 9  output DP-6
			workspace 10 output DP-6

		### Input configuration
			# Mousepad
			input "2:14:SynPS/2_Synaptics_TouchPad" {
				dwt enabled
				tap enabled
				natural_scroll enabled
				middle_emulation enabled
			}

			input "Lenovo ThinkPad Compact USB Keyboard with TrackPoint" {
				pointer_accel 2
			}

			# Keyboard (zi is a custom layout in ~/.xkb/symbols/zi)
			input type:keyboard {
				xkb_layout "zi,dk,jp"
				repeat_rate 45
				repeat_delay 225
			}

		### Key bindings basics:
			# Start a terminal
			bindsym $mod+space exec ${term} sh -c "cd /data; zsh"
			bindsym $mod+Shift+space [app_id="popterm"] scratchpad show
			bindsym $mod+y [title="KeePassXC"] scratchpad show

			# Open programs
			bindsym $mod+a exec anki
			bindsym $mod+r exec ${term} newsboat
			bindsym $mod+w exec env all_proxy="socks5://10.64.0.1:1080" librewolf
			bindsym $mod+s exec ${screenshot}
			bindsym $mod+Shift+s exec ${screenshot-area}
			bindsym $mod+m exec ${term} neomutt
			bindsym $mod+p exec ${term} pulsemixer
			bindsym $mod+n exec nheko

			# Shutdown
			bindsym $mod+Escape exec sudo shutdown 0
			bindsym $mod+Shift+Escape exec sudo reboot 0

			# Misc
			bindsym $mod+z exec ${toggle-gammastep}
			bindsym $mod+semicolon exec swaylock
			bindsym $mod+Shift+semicolon exec swaymsg input "type:keyboard" xkb_switch_layout next
			bindsym $mod+ae exec swaylock
			bindsym $mod+Shift+ae exec swaymsg input "type:keyboard" xkb_switch_layout next
			bindsym $mod+u exec ${set-volume} -5
			bindsym $mod+i exec ${set-volume} +5
			bindsym $mod+o exec pactl set-sink-mute @DEFAULT_SINK@ toggle

			# Kill focused window
			bindsym $mod+q kill

			# Start your launcher
			bindsym $mod+d exec ${menu}

			# Open link in firefox application mode
			bindsym $mod+Shift+d exec firefox

			# Drag floating windows by holding down $mod and left mouse button.
			floating_modifier $mod normal

			# Reload the configuration file
			bindsym $mod+e reload

			# Exit sway (logs you out of your Wayland session)
			bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'

		### Moving around:
			bindsym $mod+$left focus left
			bindsym $mod+$down focus down
			bindsym $mod+$up focus up
			bindsym $mod+$right focus right

			bindsym $mod+Left focus left
			bindsym $mod+Down focus down
			bindsym $mod+Up focus up
			bindsym $mod+Right focus right

			bindsym $mod+Shift+$left move left
			bindsym $mod+Shift+$down move down
			bindsym $mod+Shift+$up move up
			bindsym $mod+Shift+$right move right

			bindsym $mod+Shift+Left move left
			bindsym $mod+Shift+Down move down
			bindsym $mod+Shift+Up move up
			bindsym $mod+Shift+Right move right

		### Workspaces:
			# Switch to workspace
			bindsym $mod+1 workspace number 1
			bindsym $mod+2 workspace number 2
			bindsym $mod+3 workspace number 3
			bindsym $mod+4 workspace number 4
			bindsym $mod+5 workspace number 5
			bindsym $mod+6 workspace number 6
			bindsym $mod+7 workspace number 7
			bindsym $mod+8 workspace number 8
			bindsym $mod+9 workspace number 9
			bindsym $mod+0 workspace number 10

			# Move focused container to workspace
			bindsym $mod+Shift+1 move container to workspace number 1
			bindsym $mod+Shift+2 move container to workspace number 2
			bindsym $mod+Shift+3 move container to workspace number 3
			bindsym $mod+Shift+4 move container to workspace number 4
			bindsym $mod+Shift+5 move container to workspace number 5
			bindsym $mod+Shift+6 move container to workspace number 6
			bindsym $mod+Shift+7 move container to workspace number 7
			bindsym $mod+Shift+8 move container to workspace number 8
			bindsym $mod+Shift+9 move container to workspace number 9
			bindsym $mod+Shift+0 move container to workspace number 10

		### Layout stuff:
			# Make the current focus fullscreen
			bindsym $mod+f fullscreen

			# Toggle the current focus between tiling and floating mode
			bindsym $mod+Shift+Return floating toggle

			# Swap focus between the tiling area and the floating area
			bindsym $mod+return focus mode_toggle

		### System keybinds
			bindsym XF86AudioRaiseVolume exec ${set-volume} +5
			bindsym XF86AudioLowerVolume exec ${set-volume} -5
			bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
			bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
			bindsym XF86MonBrightnessUp exec brightnessctl set +5%
			bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
			bindsym XF86AudioPlay exec playerctl play-pause
			bindsym XF86AudioNext exec playerctl next
			bindsym XF86AudioPrev exec playerctl previous
			bindsym XF86PowerOff exec shutdown 0
			bindsym Shift+XF86HomePage exec shutdown 0

		### Aesthetics
			# Gaps
			gaps outer 5
			gaps inner 5

			# Borders
			default_border pixel 2
			hide_edge_borders smart

			# class                 border                background         text                 indicator             child_border
			client.focused          ${colorscheme.green}  ${colorscheme.bg}  ${colorscheme.fg}    ${colorscheme.green}  ${colorscheme.green}
			client.focused_inactive ${colorscheme.bg}     ${colorscheme.bg}  ${colorscheme.bright.black}  ${colorscheme.green}  ${colorscheme.bg}
			client.unfocused        ${colorscheme.bg}     ${colorscheme.bg}  ${colorscheme.bright.black}  ${colorscheme.green}  ${colorscheme.bg}
			client.urgent           ${colorscheme.red}    ${colorscheme.bg}  ${colorscheme.fg}    ${colorscheme.green}  ${colorscheme.red}
			client.placeholder      ${colorscheme.bg}     ${colorscheme.bg}  ${colorscheme.bright.black}  ${colorscheme.green}  ${colorscheme.bg}

		### Include default config
			include @sysconfdir@/sway/config.d/*

		### Systemd shit
			exec "systemctl --user import-environment; systemctl --user start sway-session.target"
			exec --no-startup-id fcitx -d
			exec ${startup-volume}
	'';
in {
	imports = [
		(import ./submodules/waybar username colorscheme term args)
		(import ./submodules/gammastep username args)
		(import ./submodules/kanshi username args)
		(import ./submodules/gtk username args)
		(import ./submodules/swayidle username colorscheme args)
		(import ./submodules/autotile username args)
		(import ./submodules/powercheck username args)
	];

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true; # so that gtk works properly
		extraPackages = with pkgs; [
			wl-clipboard
			wf-recorder
			wofi
			slurp
			grim
			brightnessctl
			playerctl
			pulsemixer
			pulseaudio
			pamixer
			jq
		];
	};

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/sway/config - - - - ${sway-config}"
		"L+ /home/user/.xkb - - - - ${./link/xkb}"
	];

	# Allow user to run commands without sudo: brightnessctl, reboot, shutdown
	security.sudo.extraConfig = ''
		${username} ALL = (root) NOPASSWD: /run/current-system/sw/bin/brightnessctl
		${username} ALL = (root) NOPASSWD: /run/current-system/sw/bin/reboot
		${username} ALL = (root) NOPASSWD: /run/current-system/sw/bin/shutdown
	'';

	# Autologin
	services.getty.autologinUser = username;

	environment.variables = {
		MOZ_ENABLE_WAYLAND = "1";
		QT_QPA_PLATFORM = "wayland-egl";
	};

	# Autostart sway
	environment.loginShellInit = ''
		if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
			exec sway
		fi
	'';

	systemd.user.targets.sway-session = {
		description = "Sway compositor session";
		documentation = [ "man:systemd.special(7)" ];
		bindsTo = [ "graphical-session.target" ];
		wants = [ "graphical-session-pre.target" ];
		after = [ "graphical-session-pre.target" ];
	};
}
