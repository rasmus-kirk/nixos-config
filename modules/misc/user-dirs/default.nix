username: { config, pkgs, lib, ... }:
let
	user-dirs = builtins.toFile "user-dirs.dirs" ''
		XDG_DESKTOP_DIR="/data"
		XDG_DOCUMENTS_DIR="/data/documents"
		XDG_DOWNLOAD_DIR="/data/downloads/unsorted"
		XDG_MUSIC_DIR="/data/media/audio/music"
		XDG_PICTURES_DIR="/data/media/images"
		XDG_VIDEOS_DIR="/data/media/videos"
	'';
in {
	environment.systemPackages = with pkgs; [
		xdg-user-dirs
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/user-dirs.dirs - - - - ${user-dirs}"
	];
}
