{ config, pkgs, ... }:
{
  system.userActivationScripts.zshrc = "touch .zshrc";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "duellj";
      plugins = [
        "git"
        "bundler"
        "dotenv"
        "rake"
        "rbenv"
        "ruby"
      ];

    };
    interactiveShellInit = ''
      export CASE_SENSITIVE="true"
      export HYPHEN_INSENSITIVE="true"
      export ENABLE_CORRECTION="true"
      export COMPLETION_WAITING_DOTS="true"
      export LANG=en_US.UTF-8
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      alias d='dirs -v'
      for index ({1..9}) alias "$index"="cd +''${index}"; unset index
      autoload -Uz surround
      zle -N delete-surround surround
      zle -N add-surround surround
      zle -N change-surround surround
      bindkey -M vicmd cs change-surround
      bindkey -M vicmd ds delete-surround
      bindkey -M vicmd ys add-surround
      bindkey -M visual S add-surround
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      fastfeatch
      alias cl ='clear'
      alias nv = 'nvim'
    '';

  };
}
