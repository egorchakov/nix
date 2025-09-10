{
  self,
  pkgs,
  user,
  ...
}: {
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  system.primaryUser = user;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    nushell
  ];

  users.users."${user}" = {
    home = "/Users/${user}";
    shell = pkgs.nushell;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${user}" = {
      imports = [./home/darwin.nix];
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = user;
    autoMigrate = true;
  };

  environment.systemPackages = with pkgs; [
    iosevka
    google-chrome
    slack
    telegram-desktop
    sioyek
  ];

  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "tunnelblick"
      "cloudflare-warp"
      "netron"
      "signal"
      "uhk-agent"
      "whatsapp"
      "spotify"
    ];
  };
}
