{ pkgs, lib, config, ... }:

{
  users.mutableUsers = false;
  users.users.ryan.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];

  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  programs.ssh.extraConfig = ''
    Host termux-pixel-4a
      HostName pixel-4a
      User u0_a342
      Port 8022

    Host pixel-4a*
      User nix-on-droid
      Port 8022
    
    Host slogin
      User rtg24
      Hostname slogin-serv.cl.cam.ac.uk
    
    Host l41
      User root
      Hostname rpi4-013.advopsys.cl.cam.ac.uk
      IdentityFile ~/.ssh/id_rsa_rpi4-013.advopsys.cl.cam.ac.uk
      ProxyJump rtg24@slogin-serv.cl.cam.ac.uk
      ForwardAgent yes
  '';
}