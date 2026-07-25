{ lib, ... }:
{
  home.activation.finderSidebar = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    MYSIDES="/opt/homebrew/bin/mysides"

    if [ -x "$MYSIDES" ]; then
      /bin/mkdir -p "$HOME/Code"

      "$MYSIDES" list 2>/dev/null | /usr/bin/awk -F'\t' '{print $1}' | while IFS= read -r name; do
        [ -n "$name" ] && "$MYSIDES" remove "$name" >/dev/null 2>&1
      done

      "$MYSIDES" add ryanstoffel "file://$HOME/"
      "$MYSIDES" add Code "file://$HOME/Code/"
      "$MYSIDES" add Documents "file://$HOME/Documents/"
      "$MYSIDES" add Downloads "file://$HOME/Downloads/"
      "$MYSIDES" add Applications "file:///Applications/"
      "$MYSIDES" add Pictures "file://$HOME/Pictures/"
    fi
  '';
}
