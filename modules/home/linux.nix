{...}: let
  username = "evgenii";
in {
  home.username = username;
  home.homeDirectory = "/home/${username}";
}
