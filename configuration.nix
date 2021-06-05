# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.initrd.checkJournalingFS = false;
  boot.kernel.sysctl = {"net.ipv4.ip_forward" = 1;};

  networking.hostName = "Koom"; # Define your hostname.
  
  # Set your time zone.
  time.timeZone = "UTC";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Matthew = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    tailscale
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;  
  
  services.tailscale.enable = true;
  services.qemuGuest.enable = true;
  #services.nginx = {
    #enable = false;
    #recommendedProxySettings = true;
    #recommendedTlsSettings = true;
    # other Nginx options
    #virtualHosts."koom.tatmanhui.com" =  {
      #enableACME = true;
      #forceSSL = true;
      #locations."/unifi/" = {
       # proxyPass = "https://dunmanifestin:8443";
        #proxyWebsockets = true; # needed if you need to use WebSocket
        #extraConfig =
          # required when the target is also TLS server with multiple hosts
          #"proxy_ssl_server_name on;" +
          # required when the server wants to use HTTP Authentication
          #"proxy_pass_header Authorization;"
         # ;
      #};
   # };
  #};

  #security.acme = {
  #  email = "m@tatmanhui.com";
  #  acceptTerms = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [ 41641 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

