{ pkgs, ... }: {
  boot.isContainer = true;
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * root tar cazf /tmp/backup.tar.gz /media && rsync /tmp/backup.tar.gz /mnt/$(date +%s).tar.gz"
    ];
  };
  environment.systemPackages = with pkgs; [ rsync ];
}
