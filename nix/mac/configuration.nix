{
  pkgs,
  self,
  ...
}:
{
  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.primaryUser = "loganphinney";
  networking.hostName = "mac-loganp";
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@admin"
        "loganphinney"
      ];
      auto-optimise-store = true;
    };
  };
  users.users.loganphinney = {
    name = "loganphinney";
    home = "/Users/loganphinney";
  };
  security.sudo.extraConfig = ''
    %admin ALL=(ALL) NOPASSWD: ALL
  '';
  security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
  };
  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };
  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;
  environment.systemPackages = with pkgs; [
    git
    rsync
    wget
    curl
    openssl
    openssh
    dnslookup
    nmap
    tmux
    nano
    fzf
    bat
    ripgrep
    fd
    eza
    stow
    btop
    unixtools.watch
    gnumake
    cargo
    nh
    docker-compose
    fastfetch
    lazygit
    lazydocker
    python313
    perl
    ruby
    lua
    ffmpeg
    yt-dlp
    # neovim
    neovim-unwrapped
    tree-sitter
    luajitPackages.jsregexp
    # language servers
    shellcheck
    shfmt
    bash-language-server
    pyright
    ruff
    perl5Packages.PLS
    lua-language-server
    nixd
    nixfmt
    typescript-language-server
    terraform-ls
    sourcekit-lsp
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.noto
  ];
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    casks = [
      "docker-desktop"
      "macs-fan-control"
      "yubico-authenticator"
      "protonvpn"
    ];
  };
}
