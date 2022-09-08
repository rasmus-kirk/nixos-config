username: colorscheme: { config, pkgs, lib, ... }:
{
	users.extraUsers."${username}" = {
		shell = pkgs.zsh;
	};

	programs.zsh = {
		enable = true;
		autosuggestions = {
			enable = true;
			strategy = ["match_prev_cmd"];
		};
		syntaxHighlighting = {
			enable = true;
			highlighters = [ "main" ];
		};
		histFile = "/data/.state/zsh/history";
		ohMyZsh = {
			enable = true;
			custom = "${./link/custom}";
			theme = "gruvbox";
		};

		shellAliases = {
			nix-shell = "nix-shell --run 'clear; zsh'";

			screenshare = "sudo modprobe v4l2loopback video_nr=2 card_label='screenshare' && wf-recorder --muxer=v4l2 -f /dev/video2 -c rawvideo -x yuyv422;sudo modprobe --remove v4l2loopback";

			yt-dl     = "yt-dlp -i --add-metadata $(wl-paste)";
			mp3-dl    = "yt-dlp -i --add-metadata --extract-audio --audio-format mp3 -o '/data/downloads/audio/%(title)s.%(ext)s' $(wl-paste)";
			vid-dl    = "yt-dlp -i --add-metadata -o '/data/downloads/unsorted/%(title)s.%(ext)s' $(wl-paste)";
			dee-dl    = "deemix -p /data/downloads/audio -b FLAC $(wl-paste)";

			mv        = "mv -vi";
			cp        = "cp -vi";
			rm        = "rm -vI";
			mkdir     = "mkdir -pv";

			ls        = "ls -hN --color=auto --group-directories-first";
			grep      = "grep --color=auto";
			diff      = "diff --color=auto";
			ccat      = "highlight --out-format=ansi";
		};

		interactiveShellInit = ''
			#If not running interactively, don't do anything
			[[ $- != *i* ]] && return
		'';
	};

	systemd.tmpfiles.rules = [
		"d /data/.state/zsh         - ${username} - - -"
		"f /home/${username}/.zshrc - ${username} - - -"
	];
}
