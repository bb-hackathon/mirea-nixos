{ ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  programs.ssh.startAgent = true;
  security.pam.enableSSHAgentAuth = true;
}
