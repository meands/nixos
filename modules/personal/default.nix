{ pkgs, config, lib, ... }:

let cfg = config.personal; in
{
  imports = [
    ./shell.nix
    ./ssh.nix
    ./nix-index.nix
    ./wireguard-hosts.nix
    ./laptop.nix
    ./ocaml.nix
    ./tailscale.nix
  ];

  options.personal = {
    enable = lib.mkEnableOption "personal";
  };

  config = lib.mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      keyMap = "uk";
    };

    users = let
      hashedPassword = "$6$tX0uyjRP0KEeHbCe$tz2MmUInPh/y/nE6Xy1am4OfNvffLvynb/tB9HskzmaGiatCzlSEcVnPkM6vCXNxzjU4dDgda85HG3kz/XZEs/";
    in {
      mutableUsers = false;
      users.${config.custom.username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # enable sudo
        shell = pkgs.zsh;
        hashedPassword = hashedPassword;
      };
      users.root.hashedPassword = hashedPassword;
    };

    environment = {
      systemPackages = with pkgs; [
        nix
        tree
        htop
        bind
        inetutils
        ncdu
        nix-prefetch-git
        gnumake
        bat
        killall
        nmap
        gcc
        direnv
        fzf
        tcpdump
        sshfs
        nix-tree
        atuin
        git-crypt
      ];
      variables.EDITOR = "nvim";
      shellAliases = {
        ls = "ls -p --color=auto";
        pls = "sudo $(fc -ln -1)";
        o = "xdg-open";
        se = "sudoedit";
        su = "su -p";
        ssh = "TERM=xterm ssh";
        nix-shell = "nix-shell --command zsh";
        inhibit-lid = "systemd-inhibit --what=handle-lid-switch sleep 1d";
        tmux = "tmux -2";
        feh = "feh --scale-down --auto-zoom";
      };
      sessionVariables = {
        NIX_AUTO_RUN = "y";
        NIX_AUTO_RUN_INTERACTIVE = "y";
      };
    };
    
    networking = rec {
      # nameservers = [ ${config.hosting.serverIpv4} ];
      nameservers = [ "1.1.1.1" ];
      networkmanager.dns = "none";
    };

    programs.git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        user = {
          email = "${config.custom.username}@${config.networking.domain}}";
          name = "Ryan Gibb";
        };
        alias = {
          s = "status";
          c = "commit";
          cm = "commit --message";
          ca = "commit --amend";
          cu = "commit --message update";
          ci = "commit --message initial";
          br = "branch";
          co = "checkout";
          df = "diff";
          lg = "log -p";
          lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
          lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
          ls = "ls-files";
          a = "add";
          aa = "add --all";
          au = "add -u";
          ap = "add --patch";
          ps = "push";
          pf = "push --force";
          pu = "push --set-upstream";
          pl = "pull";
          pr = "pull --rebase";
          acp = "!git add --all && git commit --message update && git push";
        };
      };
    };
    
    programs.bash.promptInit = ''
      PS1='\[\e[36m\]\u@\h:\W\[\e[0m\] $ '
    '';

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = builtins.readFile ./nvim.cfg;
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            vimtex
            vim-auto-save
            vim-airline
            vim-airline-themes
            palenight-vim
            vim-nix
          ];
          opt = [ ];
        };
      };
    };

    programs.tmux = {
      enable = true;
      extraConfig = ''
        set-option -g prefix `
        bind ` send-prefix
        set -g mouse on
        set-window-option -g mode-keys vi
        set -g lock-command vlock
        set -g lock-after-time 0 # Seconds; 0 = never
        bind L lock-session
      '';
    };
  };
}
