{ ... }:
{
  launchd.agents.ghostty-background = {
    enable = true;
    domain = "gui";
    config = {
      Program = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/ghostty-background.log";
      StandardErrorPath = "/tmp/ghostty-background.err.log";
    };
  };
}
