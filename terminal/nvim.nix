{lazyvim,  pkgs, ...}:
{
  programs.lazyvim = {
  treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
    angular
    clojure
    cmake
    cpp
    css
    dockerfile
    gitattributes
    gitcommit
    git_config
    gitignore
    git_rebase
    go
    gomod
    gosum
    gowork
    ninja
    ron
    rst
    ruby
    rust
    scss
    sql
    typst
    vue
  ];
 };
}
