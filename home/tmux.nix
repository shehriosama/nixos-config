{ lib, config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 100000;
    sensibleOnTop = false; # avoid home-manager reordering surprises

    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
       # Fix colors esp. nvim
       set-option -sa terminal-overrides ",xterm*:Tc"
       
       ## +--- Themes ---+ ##
       # Materuial darker
       run-shell $HOME/.tmux/plugins/material-darker/material_darker.tmux

       
       ## +--- Fix Keys ---+ ##
       # Shift Alt vim keys to switch windows
       bind -n M-H previous-window
       bind -n M-L next-window
       # Better prefix key
       unbind C-b
       set -g prefix C-Space
       bind C-Space send-prefix
       # Enable mouse
       set -g mouse on
       # set vi-mode
       set-window-option -g mode-keys vi
       # keybindings
       bind-key -T copy-mode-vi v send-keys -X begin-selection
       bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
       bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
       
       ## Start windows and panes at 1, not 0
       set -g base-index 1
       set -g pane-base-index 1
       set-window-option -g pane-base-index 1
       set-option -g renumber-windows on
       
       # Open panes in current directory
       bind '"' split-window -v -c "#{pane_current_path}"
       bind % split-window -h -c "#{pane_current_path}"
       
       # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
       run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}

