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

  environment.systemPackages = with pkgs; [
    nextdns
  ];

  users.users."${user}" = {
    home = "/Users/${user}";
    shell = pkgs.nushell;
  };

  homebrew = {
    enable = true;
    greedyCasks = true;
    casks = [
      "tunnelblick"
      "cloudflare-warp"
      "netron"
      "signal"
      "uhk-agent"
      "spotify"
    ];
  };
}
