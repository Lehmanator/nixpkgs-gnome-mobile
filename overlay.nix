self: super: {
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
      version = "unstable-2023-09-08";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "df3f6b4c512d2f181e86ff7f6b1646ce7b907344";
        hash = "sha256-s47z1q+MZWogT99OkzgQxKrqFT4I0yXyfGSww1IaaFs=";
        fetchSubmodules = true;
      };
      # JS ERROR: Error: Requiring ModemManager, version none: Typelib file for namespace 'ModemManager' (any version) not found
      # @resource:///org/gnome/shell/misc/modemManager.js:4:49
      buildInputs = old.buildInputs ++ [ super.modemmanager ];
      postPatch = ''
        patchShebangs src/data-to-c.pl

        # We can generate it ourselves.
        rm -f man/gnome-shell.1

        # Build fails with -Dgtk_doc=true
        # https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/6486
        # element include: XInclude error : could not load xxx, and no fallback was found
        substituteInPlace docs/reference/shell/shell-docs.sgml \
          --replace '<xi:include href="xml/shell-embedded-window.xml"/>' ' ' \
          --replace '<xi:include href="xml/shell-gtk-embed.xml"/>' ' '
      '';
    });
    gnome-shell-devel = gself.gnome-shell.overrideAttrs (old: {
      version = "unstable-2023-10-22";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "58146d2cce4f81a2eb2de0721bb730040f0e6118";
        hash = "sha256-b9TJlePcBi9njlly7Qx5UpfLj9pbTQUaB9rztNcnUMA=";
        fetchSubmodules = true;
      };
    });

    mutter = gsuper.mutter.overrideAttrs (old: {
      version = "unstable-2023-09-08";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "0f08f5aba4c9b5ac34b2d5711182d50b719d838e";
        hash = "sha256-du56QMOlM7grN60eafoGTw2JGND6PK1gLrfWufihPO4=";
      };
    });
    mutter-devel = gself.mutter.overrideAttrs (old: {
      version = "unstable-2023-10-22";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "2c538763f7cdcd8dec29fbf602b930c60862f019";
        hash = "sha256-D9TWF09XhqfBZyKXiPaQE+Fa+3mKG2CAdyi8nAsYa+c=";
      };
    });
  });
}

