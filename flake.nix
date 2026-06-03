{
  description = "Termux packages and patches ported to nix-on-droid";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    termux-auth.url = "github:termux/termux-auth";
    termux-auth.flake = false;
    termux-packages.url = "github:termux/termux-packages";
    termux-packages.flake = false;
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    # TODO: use nix-systems
    eachSystem = lib.genAttrs ["x86_64-linux" "aarch64-linux"];
    pkgsFor = eachSystem (
      system:
        import nixpkgs {
          localSystem = system;
          overlays = [self.overlays.default];
        }
    );
  in {
    inherit inputs;
    overlays = {
      default = final: prev: {
        termux-auth = final.callPackage ./packages/termux-auth.nix {src = inputs.termux-auth;};
        termuxPackageHook = final.callPackage ./packages/termuxPackageHook.nix {};
        openssh = final.callPackage ./packages/openssh.nix {
          inherit (prev) openssh;
          termuxPkg = "${inputs.termux-packages}/packages/openssh";
        };
      };
    };

    packages = eachSystem (system: {
      inherit (pkgsFor.${system}) termux-auth termuxPackageHook openssh;

      # TODO: not sure what the convention is with cross compilation
      crossPkgs = eachSystem (crossSystem: let
        crossPkgs = import nixpkgs {
          localSystem = system;
          inherit crossSystem;
          overlays = [self.overlays.default];
        };
      in {
        inherit (crossPkgs) termux-auth termuxPackageHook openssh;
      });
    });

    ciHelpers = eachSystem (system: {
      testTargets = eachSystem (
        crossSystem: let
          crossPkgs = import nixpkgs {
            localSystem = system;
            inherit crossSystem;
            overlays = [self.overlays.default];
          };
        in
          crossPkgs.stdenvNoCC.mkDerivation {
            name = "nixdroidpkgs-ci-test-target";
            src = ./.;
            outputs = ["out"];
            installPhase = "mkdir -p $out";
            buildInputs = with crossPkgs; [termux-auth openssh];
          }
      );
    });
  };
}
