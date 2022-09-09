username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		newsboat
	];

	systemd.tmpfiles.rules = [
		"d /data/.state/newsboat - ${username} - - -"
		"d /home/${username}/.config/newsboat - ${username} - - -"

		"L+ /home/${username}/.local/share/newsboat         - - - - /data/.state/newsboat"
		"L+ /home/${username}/.config/newsboat/linkhandler  - - - - ${./link/linkhandler}"
		"L+ /home/${username}/.config/newsboat/config       - - - - ${./link/config}"
		"C /home/${username}/.config/newsboat/urls         - ${username} - - ${config.age.secrets.newsboat-urls.path}"
	];

	services.cron = {
		enable = true;
		systemCronJobs = [
			"*/17 * * * *  ${username}  newsboat -x reload"
			"@reboot       ${username}  newsboat -x reload"
		];
	};
}
