{ pkgs, config, lib, eilean, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  custom = {
    enable = true;
    tailscale = true;
  };

  home-manager.users.${config.custom.username}.config.custom.machineColour =
    "yellow";

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  swapDevices = [{
    device = "/var/swap";
    size = 2048;
  }];
}
