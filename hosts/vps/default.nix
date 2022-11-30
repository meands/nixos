{ pkgs, config, lib, ... }:

let giteaSshPort = 3001; in
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "vps";
  personal = {
    enable = true;
    machineColour = "yellow";
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  swapDevices = [ { device = "/var/swap"; size = 2048; } ];

  hosting = {
    mailserver = true;
    matrix = true;
    freumh = true;
    mastodon = true;
    gitea = true;
    nix-cache = true;
    dns = true;
  };

  services.tailscale.enable = true;

  services.ryan-website.enable = true;
  services.ryan-website.cname = "vps";

  services.twitcher.enable = true;
  services.twitcher.cname = "vps";
  services.twitcher.dotenvFile = "${config.custom.secretsDir}/twitcher.env";

  networking.firewall = {
    # keep tight control over open ports
    allowedTCPPorts = lib.mkForce [
      22  # SSH
      giteaSshPort
      25  # SMTP
      465 # SMTP TLS
      53  # DNS (over TCP)
      80  # HTTP
      443 # HTTPS
      993 # IMAP
    ];
    allowedUDPPorts = lib.mkForce [
      53    # DNS
      51820 # wireguard
    ];
    trustedInterfaces = [ "tailscale0" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # proxy port 22 on ethernet interface to internal gitea ssh server
  # openssh server remains accessible on port 22 via vpn(s)
  services.gitea.settings.server = {
    START_SSH_SERVER = true;
    SSH_LISTEN_PORT = giteaSshPort;
  };
  networking.firewall.extraCommands = ''
    iptables -A PREROUTING -t nat -i enp1s0 -p tcp --dport 22 -j REDIRECT --to-port ${builtins.toString giteaSshPort}
    ip6tables -A PREROUTING -t nat -i enp1s0 -p tcp --dport 22 -j REDIRECT --to-port ${builtins.toString giteaSshPort}

    # proxy locally originating outgoing packets
    iptables -A OUTPUT -d ${config.hosting.serverIpv4} -t nat -p tcp --dport 22 -j REDIRECT --to-port ${builtins.toString giteaSshPort}
    ip6tables -A OUTPUT -d ${config.hosting.serverIpv6} -t nat -p tcp --dport 22 -j REDIRECT --to-port ${builtins.toString giteaSshPort}
  '';
}
