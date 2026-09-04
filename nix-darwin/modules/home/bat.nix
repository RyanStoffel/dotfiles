{ ... }:
{
  # Stock bat theme, which delta also picks up through bat's theme cache
  # (see git.nix).
  programs.bat = {
    enable = true;
    config.style = "numbers,changes";
  };
}
