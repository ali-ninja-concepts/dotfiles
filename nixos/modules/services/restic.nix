{ pkgs, ... }:

{
  services.restic.backups.system = {
    initialize = true;

    repository = "s3:s3.us-east-005.backblazeb2.com/zai-nix";
    environmentFile = "/root/.secrets/restic-b2-env";
    passwordFile = "/root/.secrets/restic-password";

    paths = [
      "/home"
      "/var/backup/postgresql"
      "/etc/nixos"
    ];

    exclude = [
      # Caches & build artifacts
      ".cache"
      "node_modules"
      ".next"
      "target"
      "dist"
      "__pycache__"
      ".turbo"
      ".gradle"
      ".dart-tool"
      ".pub-cache"
      # Package managers (reinstallable)
      ".nvm"
      ".npm"
      ".npm-global"
      ".bun"
      "go/pkg"
      # Trash & temp
      ".local/share/Trash"
      ".compose-cache"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql_16}/bin/pg_dumpall > /var/backup/postgresql/all-databases.sql
    '';

    backupCleanupCommand = ''
      rm -f /var/backup/postgresql/all-databases.sql
    '';
  };

  # Ensure dump directory exists
  systemd.tmpfiles.rules = [
    "d /var/backup/postgresql 0700 root root -"
  ];
}
