username: { config, pkgs, lib, ... }:
let
	word-of-the-day = pkgs.writeShellScript "word-of-the-day" ''
		path=/data/.state/jiten/word-of-the-day

		mkdir -p $path
		if ! [ "$(cat $path/last-update.txt)" = "$(date +"%Y-%m-%d")" ]; then
			jiten --colour -v jmdict --romaji -n 1 +random > $path/japanese.txt
			date +"%Y-%m-%d" > $path/last-update.txt
		fi
	'';

	jisho = pkgs.writeShellScriptBin "jisho" ''
		numOfResults="3"

		if [[ $1 == "-e" ]]; then
			jiten -v jmdict --max $numOfResults --word $2
		elif [[ $1 == "-e" ]]; then
			echo ""
		else
			if [[ $1 == "" ]]; then
				x="$(wl-paste)"
			else
				x="$1"
			fi

			jiten -v jmdict --hiragana --max $numOfResults --exact $x
		fi
	'';

in {
	environment.systemPackages = with pkgs; [
		jiten
		jisho
	];

	environment.interactiveShellInit = ''
		cat /data/.state/jiten/word-of-the-day/japanese.txt | head -n -1 | tail -n +4
		echo ""
	'';

	environment.shellAliases = {
		hiragana = "cat ${./link/hiragana.txt}";
		katakana = "cat ${./link/hiragana.txt}";
	};

	services.cron = {
		enable = true;
		systemCronJobs = [
			"*/13 * * * *  ${username}  ${word-of-the-day}"
			"@reboot       ${username}  ${word-of-the-day}"
		];
	};
}

