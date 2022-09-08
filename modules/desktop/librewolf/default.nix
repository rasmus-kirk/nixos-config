username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		librewolf-wayland
	];

	systemd.tmpfiles.rules = [
		"d  /data/.state/librewolf - ${username} - - -"

		"L+ /home/${username}/.librewolf - - - - /data/.state/librewolf"
	];

	environment.variables = {
		MOZ_ENABLE_WAYLAND="1";
		BROWSER="librewolf";
	};
}
