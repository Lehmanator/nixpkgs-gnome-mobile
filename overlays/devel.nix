self: super: {
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
      version = "unstable-2024-02-12";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "259e12cfbe7060cdf63e106d275c0ee0d0158906";
        hash = "sha256-h3Qk1VhQDuXU9Y46hOMgO6OlYpdNIylIhLCroE5YTak=";
        fetchSubmodules = true;
      };
      buildInputs = old.buildInputs ++ [super.modemmanager];
      postPatch = ''
        patchShebangs src/data-to-c.pl
        rm -f man/gnome-shell.1
        substituteInPlace docs/reference/shell/shell-docs.sgml \
          --replace '<xi:include href="xml/shell-embedded-window.xml"/>' ' ' \
          --replace '<xi:include href="xml/shell-gtk-embed.xml"/>' ' '
      '';
    });

    mutter = gsuper.mutter.overrideAttrs (old: {
      version = "unstable-2024-02-12";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "742ac7a4fe1cacb1ff1ee21f132947c19b9498b7";
        hash = "sha256-RxLJszk1smR/OwotK8pjSB1mgAVv+iWUFsSV1h3SuT8=";
        #super.lib.fakeHash; # "sha256-D9TWF09XhqfBZyKXiPaQE+Fa+3mKG2CAdyi8nAsYa+c=";
      };
    });
  });
}
