{
  description = "Orca Slicer package flake (based on nixpkgs orca-slicer)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.permittedInsecurePackages = [ "ilmbase-2.5.10" ];
      };

      orcaSrc = {
        version = "2.4.0-alpha";
        srcHash = "sha256-xhmmHtVsLn4d1Q577ZNXYPzwsBsScfecx4ckLpceJqU=";
      };

      orca-slicer = pkgs.callPackage ./package.nix {
        orcaVersion = orcaSrc.version;
        orcaSrcHash = orcaSrc.srcHash;
      };
    in
    {
      packages.${system} = {
        default = orca-slicer;
        orca-slicer = orca-slicer;
      };

      overlays.default = final: prev: { orca-slicer = orca-slicer; };
    };
}
