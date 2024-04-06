{ pkgs, config, lib, eilean, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  home-manager.users.${config.custom.username}.config.custom.machineColour =
    "green";

  services.openssh.openFirewall = true;

  swapDevices = [{
    device = "/var/swap";
    size = 1024;
  }];
}
