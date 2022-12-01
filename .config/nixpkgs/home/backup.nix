{ config, pkgs, ... }:

let
  borgmaticConfig = "%h/.config/borgmatic/config.yaml";

in {
  home.packages = with pkgs; [
    borgbackup
    borgmatic
  ];

  systemd.user.services.borgmatic = {
    Unit = {
      Description = "Borgmatic backup";
      ConditionPathExists = borgmaticConfig;
    };
    Service = {
      ExecStart = "${pkgs.borgmatic}/bin/borgmatic --config ${borgmaticConfig} --verbosity 1";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers.borgmatic = {
    Unit = {
      Description = "Borgmatic backup";
      ConditionPathExists = borgmaticConfig;
    };
    Timer = {
      OnCalendar = "daily";
      RandomizedDelaySec = "5m";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
