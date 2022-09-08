username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		calcurse
		ripgrep
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/calcurse              - ${username} - - -"
		"d  /home/${username}/.config/calcurse - ${username} - - -"

		"L+ /home/${username}/.config/calcurse/conf - - - - ${./link/conf}"
		"L+ /home/${username}/.config/calcurse/keys - - - - ${./link/keys}"
		"L+ /home/${username}/.local/share/calcurse - - - - /data/.state/calcurse"
	];

	environment.shellAliases = {
		calcurse = "calcurse";
	};

	# Prints todays events on interactive shell initialization
	environment.interactiveShellInit = ''
			calcurse --output-datefmt "%Y-%m-%d" -a | rg -A 99 -B 99 --color always --colors 'match:fg:green' "[0-9][0-9]:[0-9][0-9]" | rg -A 99 -B 99 --color always --colors 'match:fg:yellow' "\->" | rg -A 99 -B 99 --color always --colors 'match:fg:cyan' "[0-9]{4}-[0-9]{2}-[0-9]{2}:" | rg -A 99 -B 99 --color always --colors 'match:fg:yellow' "^ -"
			echo ""
	'';
}

