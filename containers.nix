{ config, lib, pkgs, ... }:

{
  containers = {
    restic = {
      config = { config, pkgs, ... }: {
        services.restic.backups = {
          local = {
            passwordFile = "/dev/null";
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
    };
    duplicati = {
      config = { config, pkgs, ... }: {
        services.duplicati = {
          enable = true;
          user = "root";
        };
        users.users.duplicati.isNormalUser = true;
        users.users.duplicati.group = "duplicati";
        users.groups.duplicati = { };
      };
    };
    rsync = {
      config = { config, pkgs, ... }: {
        services.cron = {
          enable = true;
          systemCronJobs = [
            "0 * * * * root tar cazf /tmp/backup.tar.gz /home/pg && rsync /tmp/backup.tar.gz /mnt/$(date +%s).tar.gz"
          ];
        };
        environment.systemPackages = with pkgs; [ rsync ];
      };
    };
  };
}
