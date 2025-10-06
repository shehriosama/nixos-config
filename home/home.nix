{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./tmux.nix
  ];

  home.username = "osama";
  home.homeDirectory = "/home/osama";
  home.stateVersion = "25.05";
  home.sessionVariables = {
    EDITOR = "nvim";
  };


  # Enable Git
  programs.git = {
    enable = true;
    userName  = "shehriosama";
    userEmail = "ashehrigit19@gmail.com";
  };
}
