{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  system.stateVersion = "26.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "determinate-lab";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  users.users.loganp = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "media"
    ];
    shell = pkgs.zsh;
    # packages = with pkgs; [ ];
  };
  security.sudo.wheelNeedsPassword = false;
  environment.systemPackages = with pkgs; [
    gcc
    neovim
    git
    wget
    curl
    rsync
    btop
    lazydocker
    lazygit
    eza
    fd
    ripgrep
    gnumake
    python314
    kitty.terminfo
  ];
  programs.zsh.enable = true;
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
    };
  };
  services.fail2ban.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];
  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.loganphinney.com".extraConfig = ''
      reverse_proxy localhost:8096
    '';
    virtualHosts."immich.loganphinney.com".extraConfig = ''
      reverse_proxy localhost:2283
    '';
  };
  services = {
    jellyfin = {
      enable = true;
      group = "media";
      openFirewall = true;
    };
    immich = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };
  };
  users.groups.media = {
    members = [
      "jellyfin"
    ];
  };
}
