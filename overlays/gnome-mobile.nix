self: super: {
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    gnome-shell = gsuper.gnome-shell.overrideAttrs (old: {
      version = "unstable-2024-04-29";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "b157a30ad43865e41e6cf5a632390d630b5a40df";
        hash = "sha256-DGz9TGgKs40Vx6FKZ5lsaAUtjEn61ZzRpF3UEP68PKM=";
        fetchSubmodules = true;
      };
      # JS ERROR: Error: Requiring ModemManager, version none: Typelib file for namespace 'ModemManager' (any version) not found
      # @resource:///org/gnome/shell/misc/modemManager.js:4:49
      buildInputs = old.buildInputs ++ [ super.modemmanager ];
    });
    gnome-shell-devel = gself.gnome-shell.overrideAttrs (old: {
      version = "unstable-2024-05-14";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-shell";
        rev = "ab6658f592937d46a8d428c39c3d2a98cf9063ea";
        hash = "sha256-dMTBY87e6g1QsYFi6PnCXD6NLDdg0/3iJ1Bk7ObIY4U=";
        fetchSubmodules = true;
      };
    });

    mutter = gsuper.mutter.overrideAttrs (old: {
      version = "unstable-2023-09-05";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "0f08f5aba4c9b5ac34b2d5711182d50b719d838e";
        hash = "sha256-du56QMOlM7grN60eafoGTw2JGND6PK1gLrfWufihPO4=";
      };
    });
    mutter-devel = gself.mutter.overrideAttrs (old: {
      version = "unstable-2024-05-06";
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "verdre";
        repo = "mobile-mutter";
        rev = "9481723b9c1526ae89b4628573acbd06417bba2f";
        hash = "sha256-MRdsCRDR/x0KBo1F9bHc8TE085J1nAmFZ8xh4ZVDqNE=";
      };
    });
  });
}

