{
  self,
  pkgs,
  ...
}: let
  username = "evgenii";
  homeDirectory = "/Users/evgenii";
in {
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;
  system.primaryUser = username;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    nushell
  ];

  users.users."${username}" = {
    home = homeDirectory;
    shell = pkgs.nushell;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${username}" = {
      imports = [./home/darwin.nix];
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
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
