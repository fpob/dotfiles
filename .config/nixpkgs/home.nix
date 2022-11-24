{ config, pkgs, lib, ... }:

let
  onNixos = builtins.pathExists /etc/NIXOS;

in {
  imports = lib.optionals
    (builtins.pathExists ./home)
    (builtins.filter (lib.hasSuffix ".nix") (lib.filesystem.listFilesRecursive ./home));

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = lib.mkDefault (builtins.getEnv "USER");
  home.homeDirectory = lib.mkDefault (builtins.getEnv "HOME");
  home.stateVersion = "22.05";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; lib.optionals (!onNixos) [
    zoxide
    starship
    tdrop
    just
    yj
  ];

  services.pueue = {
    enable = true;
    settings = {
      shared = {
        host = "127.0.0.1";
        port = "6924";
      };
    };
  };

  xdg.configFile."zsh/plugins/home-manager-modules.zsh".text = config.programs.zsh.initExtra;

  xdg.configFile."zsh/plugins/fzf-completion.zsh".source = "${pkgs.fzf}/share/fzf/completion.zsh";
  xdg.configFile."zsh/plugins/fzf-key-bindings.zsh".source = "${pkgs.fzf}/share/fzf/key-bindings.zsh";

  xdg.configFile."zsh/plugins/grc.zsh".text = let
    grcScript = pkgs.runCommand "grc.zsh" {} ''
      ${pkgs.gnused}/bin/sed -re 's/\$\{commands\[\$0\]\}/$0/' ${pkgs.grc}/etc/grc.zsh > $out
    '';
  in ''
    source ${grcScript}
    # Disable GRC highligting for some commands.
    unset 'functions[ls]'
    unset 'functions[mtr]'
  '';

  xdg.configFile."direnv/lib/nix-direnv.sh".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
}
