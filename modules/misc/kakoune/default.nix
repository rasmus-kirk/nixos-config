username: { config, pkgs, lib, ... }:
let
	kak=(
		pkgs.kakoune.override {
			plugins = with pkgs.kakounePlugins; [
				fzf-kak
				connect-kak
				kakboard
				kakoune-extra-filetypes
				kakoune-rainbow
				kakoune-state-save
				kakoune-vertical-selection
				pandoc-kak
				powerline-kak
				prelude-kak
				quickscope-kak
			];
		}
	);
in {
	environment.systemPackages = with pkgs; [
		kak
		kak-lsp
		## LSP's
		rust-analyzer
		texlab
		gopls
		haskell-language-server
		rnix-lsp
	];

	systemd.tmpfiles.rules = [
		"L+ /home/${username}/.config/kak/kakrc - - - - ${./link/kakrc}"
		"L+ /home/${username}/.config/kak/kak-lsp/kak-lsp.toml - - - - ${./link/kak-lsp.toml}"
	];

	environment.variables = rec {
		VISUAL = "kak";
		EDITOR = VISUAL;
	};
}
