username: { config, pkgs, lib, ... }:
let
	mbsyncrc = (import ./link/mbsyncrc.nix config);
	msmtp-config = (import ./link/msmtp/config.nix config);
in {
	environment.systemPackages = with pkgs; [
		mutt-wizard
		neomutt
		isync
		msmtp
		lynx
		urlview
	];

	systemd.tmpfiles.rules = [
		"d /data/.state/mail - ${username} - - -"

		"L+ /home/user/.local/share/mail    - - - -  /data/.state/mail"
		"L+ /home/user/.mbsyncrc            - - - -  ${./link/mbsyncrc}"
		"L+ /home/user/.config/msmtp/config - - - -  ${./link/msmtp/config}"
		"L+ /home/user/.config/mutt         - - - -  ${./link/mutt}"
	];

	services.cron = {
		enable = true;
		systemCronJobs = [
			''
				*/05 * * * *  user  mbsync -a
			''
		];
	};
}

