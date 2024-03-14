{ flake, pkgs, ... }: {
  imports = [
    ./nix-index.nix
    ./neovim.nix # Uncomment this if you do not want to setup Neovim.
    ./starship.nix
    ./terminal.nix
  ];

  # Recommended Nix settings
  nix = {
    registry.nixpkgs.flake =
      flake.inputs.nixpkgs; # https://yusef.napora.org/blog/pinning-nixpkgs-flake/

    # FIXME: Waiting for this to be merged:
    # https://github.com/nix-community/home-manager/pull/4031
    # nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc

    # Garbage collect the Nix store
    gc = {
      automatic = true;
      # Change how often the garbage collector runs (default: weekly)
      # frequency = "monthly";
    };
  };
}
