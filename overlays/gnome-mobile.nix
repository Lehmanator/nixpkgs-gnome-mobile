self: super: {
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
      version = "45.2-mobile";
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
        rm -f man/gnome-shell.1
      '';
    });
    gnome-shell-devel = gself.gnome-shell.overrideAttrs (old: {
      version = "45.2-mobile-devel";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "259e12cfbe7060cdf63e106d275c0ee0d0158906";
        hash = lib.fakeHash; #"sha256-b9TJlePcBi9njlly7Qx5UpfLj9pbTQUaB9rztNcnUMA=";
        fetchSubmodules = true;
      };
      postPatch = ''
        patchShebangs src/data-to-c.pl
        rm -f man/gnome-shell.1
      '';
    });

    mutter = gsuper.mutter.overrideAttrs (old: {
      version = "45.2-mobile";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "0f08f5aba4c9b5ac34b2d5711182d50b719d838e";
        hash = "sha256-du56QMOlM7grN60eafoGTw2JGND6PK1gLrfWufihPO4=";
      };
    });
    mutter-devel = gself.mutter.overrideAttrs (old: {
      version = "45.2-mobile-devel";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "742ac7a4fe1cacb1ff1ee21f132947c19b9498b7";
        hash = lib.fakeHash; #"sha256-D9TWF09XhqfBZyKXiPaQE+Fa+3mKG2CAdyi8nAsYa+c=";
      };
    });
  });
}

