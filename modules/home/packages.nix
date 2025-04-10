{ pkgs, ... }:
let
  bat-cappuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "b19bea35a85a32294ac4732cad5b0dc6495bed32";
    sha256 = "sha256-POoW2sEM6jiymbb+W/9DKIjDM1Buu1HAmrNP0yC2JPg=";
  };
in
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    omnix

    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake
    fzf
    sad
    bottom
    coreutils
    ghostscript
    just
    tmate
    go
    process-compose
    rustup
    yazi
    # llvm_12
    inetutils
    podman
    podman-tui

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt

    #Formatters
    jq
    nixfmt
    haskellPackages.hindent
    haskellPackages.cabal-fmt
    # haskellPackages.ghcup
    prettierd
    stylua
    black
    codespell
    cmake-format
    # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
    # work.
    less
  ];

  home.shellAliases = {
    g = "git";
    lg = "lazygit";
    v = "nvim";
    t = "tmux";
    cb = "cabal build";
    ce = "cabal exec";
    cr = "cabal run";
  };
  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Better `cat`
    bat = {
      enable = true;
      themes = {
        catppuccin-mocha = {
          src = bat-cappuccin;
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      config = { theme = "catppuccin-mocha"; };
    };
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
    # Tmate terminal sharing.
    tmate = {
      enable = true;
      #host = ""; #In case you wish to use a server other than tmate.io 
    };
    htop.enable = true;

  };
}
