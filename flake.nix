{
	description = "My system config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, agenix, ... }@inputs:
	let
		system = "x86_64-linux";

		pkgs = import nixpkgs {
			inherit system;
			config = {allowUnfree = true;};
		};

		lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			laptop = lib.nixosSystem {
				inherit system;

				modules = [
					./system/laptop/configuration.nix
					agenix.nixosModule
				];

				specialArgs = { inherit inputs; };
			};
		};
	};
}
