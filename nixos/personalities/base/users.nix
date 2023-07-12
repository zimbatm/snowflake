{ pkgs, config, ... }:
{
  users.mutableUsers = false;
  users.users = {
    anthony = {
      isNormalUser = true;
      shell = pkgs.fish;
      passwordFile = config.sops.secrets.anthony-password.path;
      openssh.authorizedKeys.keys = [
        (builtins.readFile ../../../home-manager/users/anthony/yubi.pub)
        (builtins.readFile ../../../home-manager/users/anthony/e39_tpm2.pub)
      ];
      extraGroups = [ "wheel" ];
    };
  };
  sops.secrets.anthony-password = {
    sopsFile = ../../../secrets/users.yaml;
    neededForUsers = true;
  };
}
