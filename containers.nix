{ config, lib, pkgs, ... }:

{
  containers = {
    restic = {
      services.restic.backups = {
        local = {
          user = "root";
          repository = "/mnt";
          initialize = true;
          paths = [ "/home/pg" ];
          extraBackupArgs = [
            "--exclude-caches"
            "--exclude=/home/pg/VM"
            "--exclude=/home/pg/Videos"
            "--exclude=/home/pg/Music"
          ];
          pruneOpts = [
            "--keep-daily 24"
            "--keep-weekly 3"
            "--keep-monthly 12"
            "--keep-yearly 10"
          ];
          timerConfig = { OnCalendar = "hourly"; };
        };
      };
    };
    duplicati = {
      services.duplicati = {
        enable = true;
        user = "root";
      };
    };
    rsync = {
      services.cron = {
        enable = true;
        systemCronJobs = [
          "0 * * * * root tar cazf /tmp/backup.tar.gz /home/pg && rsync /tmp/backup.tar.gz /mnt/$(date +%s).tar.gz"
        ];
      };
      systemPackages = with pkgs; [ rsync tar ];
    };
  };
}
