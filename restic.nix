{ pkgs, ... }: {
  boot.isContainer = true;

  environment.systemPackages = with pkgs; [ restic ];
  services.restic.backups = {
    local = {
      passwordFile = "/dev/null";
      user = "root";
      repository = "/mnt";
      initialize = true;
      paths = [ "/media" ];
      extraBackupArgs = [ "--exclude-caches" ];
      pruneOpts = [
        "--keep-daily 24"
        "--keep-weekly 3"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      timerConfig.OnCalendar = "hourly";
    };
  };
}
