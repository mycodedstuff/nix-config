{ flake, pkgs, ... }:
{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = import ./nixvim.nix { inherit pkgs; } // {
    enable = true;
  };
}
