username: { config, pkgs, lib, ... }:
let
	nnn-plus-icons = pkgs.nnn.overrideAttrs (o: {makeFlags = o.makeFlags ++ ["O_NERD=1"];});
in {
	environment.systemPackages = with pkgs; [
		nnn-plus-icons
		xdragon
		trash-cli
	];

	systemd.tmpfiles.rules = [
		"d  /home/${username}/.config/nnn          - ${username} - -  -"
		"L+ /home/${username}/.config/nnn/plugins  - -           - -  ${./link/plugins}"
		"L+ /home/${username}/.config/nnn/quitcd   - -           - -  ${./link/quitcd}"
	];

	fonts.fonts = with pkgs; [
		nerdfonts
	];

	environment = {
		shellAliases = {
			N = "sudo -E nnn";
		};

		sessionVariables = {
			NNN_COLORS  = "2222";
			NNN_FCOLORS = "c10b0a0600050cf7c6080d01";
			NNN_TRASH   = "1";
			NNN_TMPFILE = "/home/${username}/.config/nnn/.lastd";

			NNN_PLUG = builtins.concatStringsSep ";" [
				"d:dragdrop"
				"f:fzopen"
				"l:create-m3u"
				"n:open-nnn"
				"p:playlist"
				"u:unpack"
			];

			NNN_BMS = builtins.concatStringsSep ";" [
				"a:/data/media/audio"
				"d:/data"
				"i:/data/media/images"
				"m:/data/media"
				"n:/data/.system-configuration"
				"p:/data/programming"
				"s:/data/documents/studies"
				"t:/data/documents/text-files"
				"u:/data/downloads/unsorted"
			];
		};

		shellInit = ''
			shell=$(echo $0 | grep -o --color=never "[^/]*$")
			if [[ $shell == "zsh" ]] || [[ $shell == "bash" ]]; then
				source ${./link/quitcd/quitcd.bash_zsh}
			elif [[ $shell == "csh" ]]; then
				source ${./link/quitcd/quitcd.csh}
			elif [[ $shell == "fish" ]]; then
				source ${./link/quitcd/quitcd.fish}
			fi
		'';
	};
}
