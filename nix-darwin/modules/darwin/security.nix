{ ... }:
{
  system.defaults.CustomUserPreferences = {
    "com.apple.screensaver" = {
      askForPassword = 1;
      askForPasswordDelay = 0;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.loginwindow = {
    GuestEnabled = false;
    SHOWFULLNAME = true;
  };

  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    allowSignedApp = true;
    enableStealthMode = true;
  };
}
