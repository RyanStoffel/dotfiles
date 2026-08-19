{ config, lib, ... }:
let
  icon = "${config.home.homeDirectory}/.dotfiles/nix-darwin/assets/vesktop.icns";
  app = "/Applications/Vesktop.app";
in
{
  # Vesktop ships the Vencord logo; swap it for a dark-mode Discord mark.
  # The icon is stored as the bundle's Finder custom icon (a top-level `Icon\r`
  # file), which sits outside Contents/ and so leaves the notarized seal intact.
  # A cask upgrade replaces the bundle and drops it, so this reapplies on every
  # rebuild.
  home.activation.vesktopIcon = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${app}" ] && [ -f "${icon}" ]; then
      run /usr/bin/osascript -l JavaScript \
        -e 'ObjC.import("AppKit")' \
        -e 'const img = $.NSImage.alloc.initWithContentsOfFile("${icon}")' \
        -e 'if (!img.js) throw new Error("icon failed to load")' \
        -e '$.NSWorkspace.sharedWorkspace.setIconForFileOptions(img, "${app}", 0)' \
        > /dev/null
      run /usr/bin/touch "${app}"
    fi
  '';
}
