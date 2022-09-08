username: { config, pkgs, lib, ... }:
{
	environment.systemPackages = with pkgs; [
		rustup
		gcc
	];

	systemd.tmpfiles.rules = [
		"d /data/.state/rust - ${username} - - -"
		"d /data/.state/rust/rustup - ${username} - - -"
		"d /data/.state/rust/cargo  - ${username} - - -"

		"L+ /home/${username}/.rustup - - - - /data/.state/rust/rustup"
		"L+ /home/${username}/.cargo  - - - - /data/.state/rust/cargo"
	];
}
