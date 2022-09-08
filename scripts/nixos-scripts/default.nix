username: nixos-conf-dir: { config, pkgs, lib, ... }:
let
	nixos-rebuild = pkgs.writeShellScript "nixos-rebuild" ''
		pushd ${nixos-conf-dir}

		git config --global --add safe.directory /data/.system-configuration
		temp=$(mktemp -u)
		curr_gen=$(ls /nix/var/nix/profiles | grep -o "^system-[0-9]*" | grep -o "[0-9]*$" | sort -n | tail -n 1)
		(( next_gen=$curr_gen + 1 ))
		git_status=$(su -c 'git status' ${username} | tail -n 1)
		system=$(readlink /nix/var/nix/profiles/$(readlink /nix/var/nix/profiles/system))

		if [[ "$git_status" = "nothing to commit, working tree clean" ]]; then
			echo "No changes made, exiting..."
			exit 1
		fi

		if [ "$EUID" -ne 0 ]; then
			echo "Please run as root"
			exit 1
		fi

		if ! [[ "$2" = "" ]]; then
			export NIXOS_LABEL="$(echo $2 | sed 's/ /_/g ; s/,//g' | tr '[:upper:]' '[:lower:]')"
		fi

		su -c "git add ." ${username} &&
		su -c "git commit -m '$(hostname) | $next_gen: $2'" ${username} &&
		echo "" &&
		echo "Rebuilding..." &&
		nix build .#nixosConfigurations.$(hostname).config.system.build.toplevel --impure -o $temp ||
		su -c 'git reset HEAD^1' ${username} &&

		if [[ "$(readlink $temp)" = "$system" ]]; then
			echo "System configuration already applied. Exiting..."
			su -c 'git reset HEAD^1' ${username}
			exit 0
		else
			nix-env -p /nix/var/nix/profiles/system --set $temp &&
			/nix/var/nix/profiles/system/bin/switch-to-configuration switch
		fi

		popd
	'';

	nixos-rollback = pkgs.writeShellScript "nixos-rollback" ''
		pushd ${nixos-conf-dir}

		if [ "$EUID" -ne 0 ]; then
			echo "Please run as root"
			exit 1
		fi

		git config --global --add safe.directory /data/.system-configuration
		temp=$(mktemp)
		sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > $temp
		gen=$(sort -n -r $temp | fzf | sed 's/^[[:space:]]*//g' | grep -o "^[0-9]*")
		latest_gen=$(tail -n 1 $temp | sed 's/^[[:space:]]*//g' | grep -o "^[0-9]*")
		git_status=$(git status | tail -n 1)

		if ! [[ "$git_status" = "nothing to commit, working tree clean" ]]; then
			if ! [[ "$gen" = "$latest_gen" ]]; then
				echo "Git working tree is not clean, please commit changes before running"
				exit 1
			fi
		fi

		hash=$(git log | grep -B 4 "$(hostname) | $gen:" | grep commit | grep -o --color=none "[^ ]*$")

		if ! [[ "$hash" == "" ]]; then
			if [[ $(echo "$hash" | wc -l) = "1" ]]; then
				sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation $gen &&
				/nix/var/nix/profiles/system/bin/switch-to-configuration test &&
				su -c "git stash" ${username} &&
				su -c "git reset --hard "$hash"" ${username} &&
				su -c "git reset --soft "HEAD@{1}"" ${username}
			else
				echo "Fatal error: multiple profiles with same git commit message, aborting..."
			fi
		else
			echo "Fatal error: could not get git hash, aborting..."
		fi

		popd
	'';

in let
	nixos-update = pkgs.writeShellScript "nixos-update" ''
		pushd ${nixos-conf-dir}

		git config --global --add safe.directory /data/.system-configuration
		git_status=$(su -c 'git status' ${username} | tail -n 1)

		if ! [[ "$git_status" = "nothing to commit, working tree clean" ]]; then
			echo "Git working tree is not clean, please rebuild or stash changes before updating"
			exit 1
		fi

		if [ "$EUID" -ne 0 ]; then
			echo "Please run as root"
			exit 1
		fi

		nix flake update &&
		${nixos-rebuild} ||
		su -c "git stash" ${username} &&
		su -c "git reset --hard "$hash"" ${username} &&
		su -c "git reset --soft "HEAD@{1}"" ${username}
		popd
	'';
in let
	nixos = pkgs.writeShellScriptBin "nixos" ''
		if [[ $1 = "rebuild" ]]; then
			${nixos-rebuild} "$@"
		elif [[ $1 = "rollback" ]]; then
			${nixos-rollback} "$@"
		elif [[ $1 = "update" ]]; then
			${nixos-update} "$@"
		else
			echo "Error: First argument must be either rebuild, rollback or update."
		fi
	'';
in {
	environment.systemPackages = with pkgs; [
		nixos
		fzf
		git
	];
}
