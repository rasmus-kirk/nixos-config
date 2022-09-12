username: colorscheme: term: wanikani: { config, pkgs, lib, ... }:
let
	get-mail = pkgs.writeShellScript "get-mail" ''
		unread=$(find /home/${username}/.local/share/mail/*/[Ii][Nn][Bb][Oo][Xx]/new -type f | wc -l 2>/dev/null)
		if [[ $unread == 0 ]]; then
			class=no_new_mail
		else
			class=new_mail
		fi
		echo '{"text":"'$unread'  ","class":"'$class'"}'
	'';

	get-news = pkgs.writeShellScript "get-news" ''
		unread=$(cat $HOME/.cache/newsboat/unread)

		if [[ $unread == 0 ]]; then
			class=no_news
		else
			class=news
		fi
		echo '{"text":"'$unread'  ","class":"'$class'"}'
	'';

	get-wanikani = pkgs.writeShellScript "get-wanikani" ''
		unread=$(cat $HOME/.cache/wanikani/unread)

		if [[ $unread == 0 ]]; then
			class=no_reviews
		else
			class=reviews
		fi
		echo '{"text":"'$unread'  日","class":"'$class'"}'
	'';

	update-wanikani = pkgs.writeShellScript "update-wanikani" ''
		curl -s "https://api.wanikani.com/v2/summary" \
			-H "Wanikani-Revision: 20170710" \
			-H "Authorization: Bearer ${config.age.secrets.newsboat-urls.path}" |
			jq ".data.reviews[0].subject_ids | length" > $HOME/.cache/wanikani/unread
	'';

	waybar-config = pkgs.writeText "config" ''
{
	"height": 30, // Waybar height (to be removed for auto height)
	"modules-left": ["sway/workspaces"],
	"modules-center": ["sway/window"],
	"modules-right": [ "custom/mail", "custom/wanikani" "pulseaudio", "network", "battery", "clock"],
	"keyboard-state": {
		"numlock": true,
		"capslock": true,
		"format": "{name} {icon}",
		"format-icons": {
			"locked": "",
			"unlocked": ""
		}
	},
	"mpd": {
		"format": "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ",
		"format-disconnected": "Disconnected ",
		"format-stopped": "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ",
		"unknown-tag": "N/A",
		"interval": 2,
		"consume-icons": {
			"on": " "
		},
		"random-icons": {
			"off": "<span color=\"#f53c3c\"></span> ",
			"on": " "
		},
		"repeat-icons": {
			"on": " "
		},
		"single-icons": {
			"on": "1 "
		},
		"state-icons": {
			"paused": "",
			"playing": ""
		},
		"tooltip-format": "MPD (connected)",
		"tooltip-format-disconnected": "MPD (disconnected)"
	},
	"clock": {
		// "timezone": "America/New_York",
		"tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
		"format-alt": "{:%Y-%m-%d}"
	},
	"battery": {
		"states": {
			// "good": 95,
			"warning": 30,
			"critical": 15
		},
		"format": "{capacity}% {icon}",
		"format-charging": "{capacity}% ",
		"format-plugged": "{capacity}% ",
		"format-alt": "{time} {icon}",
		// "format-good": "", // An empty format will hide the module
		// "format-full": "",
		"format-icons": ["", "", "", "", ""]
	},
	"network": {
		"format-wifi": "{essid} ({signalStrength}%) ",
		"format-ethernet": "{ifname}: {ipaddr}/{cidr} ",
		"format-linked": "{ifname} (No IP) ",
		"format-disconnected": "Disconnected ⚠",
		"format-alt": "{ifname}: {ipaddr}/{cidr}"
	},
	"pulseaudio": {
		// "scroll-step": 1, // %, can be a float
		"format": "{volume}% {icon}  {format_source}",
		"format-bluetooth": "{volume}% {icon} {format_source}",
		"format-bluetooth-muted": " {icon} {format_source}",
		"format-muted": " {format_source}",
		"format-source": "{volume}% ",
		"format-source-muted": "",
		"format-icons": {
			"headphone": "",
			"hands-free": "",
			"headset": "",
			"phone": "",
			"portable": "",
			"car": "",
			"default": ["", "", ""]
		},
		"on-click": "foot pulsemixer"
	},
	"custom/newsboat": {
		"return-type": "json",
		"exec": "${get-news}",
		"interval": 3,
		"signal": 1,
		"on-click": "foot newsboat",
	},
	"custom/mail": {
		"return-type": "json",
		"exec": "${get-mail}",
		"interval": 3,
		"signal": 1,
		"on-click": "foot neomutt",
	},
	"custom/wanikani": {
		"return-type": "json",
		"exec": "${get-wanikani}",
		"interval": 3,
		"signal": 1,
	}
}
	'';

		style = builtins.toFile "style.css" ''
			* {
				border: none;
				border-radius: 0;
				/* `otf-font-awesome` is required to be installed for icons */
				font-family: pango, Roboto, Helvetica, Arial, sans-serif;
				font-size: 14px;
				min-height: 0;
			}

			window#waybar {
				background-color: rgba(29, 32, 33, 0.65);
				border-bottom: 3px solid rgba(102, 92, 84, 0.5);
				color: #${colorscheme.fg};
				transition-property: background-color;
				transition-duration: .5s;
			}

			window#waybar.hidden {
				opacity: 0.2;
			}

			#workspaces button {
				padding: 0 5px;
				background-color: transparent;
				color: #${colorscheme.fg};
				/* Use box-shadow instead of border so the text isn't offset */
				box-shadow: inset 0 -3px transparent;
			}

			#workspaces button:hover {
				background: rgba(0, 0, 0, 0.2);
				box-shadow: inset 0 -3px #${colorscheme.fg};
			}

			#workspaces button.focused {
				background-color: rgba(235, 219, 178, 0.2);
				box-shadow: inset 0 -3px #${colorscheme.fg};
			}

			#workspaces button.urgent {
				background-color: #${colorscheme.orange};
			}

			#custom-newsboat,
			#custom-mail,
			#custom-wanikani,
			#clock,
			#battery,
			#network,
			#pulseaudio {
				padding: 0 10px;
				margin: 0 4px;
				color: #${colorscheme.fg};
			}

			#window,
			#workspaces {
				margin: 0 4px;
			}

			/* If workspaces is the leftmost module, omit left margin */
			.modules-left > widget:first-child > #workspaces {
				margin-left: 0;
			}

			/* If workspaces is the rightmost module, omit right margin */
			.modules-right > widget:last-child > #workspaces {
				margin-right: 0;
			}

			#custom-newsboat.news {
				background-color: #${colorscheme.green};
			}

			#custom-newsboat.no_news {
				background-color: #${colorscheme.bright.black};
			}

			#custom-mail.new_mail {
				background-color: #${colorscheme.green};
			}

			#custom-mail.no_new_mail {
				background-color: #${colorscheme.bright.black};
			}

			#custom-wanikani.reviews {
				background-color: #${colorscheme.green};
			}

			#custom-wanikani.no_reviews {
				background-color: #${colorscheme.bright.black};
			}

			#clock {
				background-color: transparent;
			}

			#battery {
				background-color: #${colorscheme.bright.black};
			}

			#battery.charging, #battery.plugged {
				background-color: #${colorscheme.green};
			}

			#battery.critical:not(.charging) {
				background-color: #${colorscheme.red};
			}

			label:focus {
				background-color: #000000;
			}

			#network {
				background-color: #${colorscheme.blue};
			}

			#network.disconnected {
				background-color: #${colorscheme.red};
			}

			#pulseaudio {
				background-color: #${colorscheme.purple};
			}

			#pulseaudio.muted {
				background-color: #${colorscheme.yellow};
			}

			#language {
				background: #00b093;
				color: #740864;
				padding: 0 5px;
				margin: 0 5px;
				min-width: 16px;
			}

			#keyboard-state {
				background: #97e1ad;
				color: #000000;
				padding: 0 0px;
				margin: 0 5px;
				min-width: 16px;
			}

			#keyboard-state > label {
				padding: 0 5px;
			}

			#keyboard-state > label.locked {
				background: rgba(0, 0, 0, 0.2);
			}
		'';
in
{
	programs.sway.extraPackages = with pkgs; [
		waybar
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/waybar/style.css  - - - -  ${style}"
		"L+ /home/${username}/.config/waybar/config     - - - -  ${waybar-config}"
	];

	services.cron = {
		enable = true;
		systemCronJobs = [
			"@reboot      ${username}  ${update-wanikani}"
			"*/5 * * * *  ${username}  ${update-wanikani}"
		];
	};

	systemd.user.services.waybar = {
		description = "Waybar";
		wantedBy = [ "graphical-session.target" ];
		partOf = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.waybar}/bin/waybar";
			RestartSec = 1;
			Restart = "always";
		};
	};
}
