{ config, lib, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.05";

  home = {
    username = "peter";
    homeDirectory = "/Users/peter";
    stateVersion = "21.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "$EDITOR";
    };
  };

  programs.bat = {
      enable = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNixDirenvIntegration = true;
  };

  programs.gh = {
    enable = true;
    editor = "nvim";
    gitProtocol = "ssh";
  };

  programs.htop = {
    enable = true;
    sortDescending = true;
    sortKey = "PERCENT_CPU";
  };

  programs.jq = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      character.success_symbol = "[➜](bold green)";
      java.style = "red dimmed"; 
      time = {
        disabled = false;
        style = "bold yellow";
      };
    };
  };

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "50eba266b0d8a952c7230fca1114cbc9fbbdfbd4";
          sha256 = "0ppmajynpb9l58xbrcnbp41b66g7p0c9l2nlsvyjwk6d16g4p4gy";
        };
      }
      {
        name = "nix-fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "c239a69122c88797b34e3721659b2ba5060ca7e7";
          sha256 = "0hvj3zqrx5vhbhcszrgd9cczkn97236zfbx7iwjx3grnk556r53c";
        };
      }
      {
        name = "foreign-env";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-foreign-env";
          rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
          sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
        };
      }
    ];

    loginShellInit = ''
      set -xg TERM xterm-256color
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      end
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        fenv source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      end
      if test -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        fenv source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      end
      set -xg PATH $HOME/bin $HOME/.cabal/bin /Users/peter/.ghcup/bin $PATH
      set -xg NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH
      set -xg FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
      set -xg TOOLCHAINS swift
      '';

    promptInit = ''
      eval (direnv hook fish)
      any-nix-shell fish --info-right | source
    '';

    shellAliases = {
      cat="bat";
      du="ncdu --color dark -rr -x";
      ping="prettyping";
      ps="procs";
      ".." = "cd ..";
      l="exa --long --header --git --all";
      g="git";
      gl="git log";
      gc="git commit -m";
      gca="git commit -am";
      gws="git status";
      ghauth="gh auth login --with-token < ~/.ghauth";
      gforksync="git fetch upstream && git merge upstream/master && git push origin master";
      grep="grep --color=auto";
      nixre="home-manager switch";
      nixedit="home-manager edit";
      nixgc="nix-collect-garbage -d";
      nixq="nix-env -qa";
      nixupdate="nix-channel --update";
      nixupgrade="nix upgrade-nix";
      nixup="nix-env -u";
      nixversion="nix eval nixpkgs.lib.version";
      nixdaemon="sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist && launchctl start org.nixos.nix-daemon";
      v="nvim";
      tabninecfg="vc /Users/peter/Library/Preferences/TabNine/TabNine.toml";
    };
  };

  xdg.configFile."fish/conf.d/plugin-bobthefish.fish".text = lib.mkAfter ''
    for f in $plugin_dir/*.fish
      source $f
    end
    '';

  home.packages = [
    pkgs.any-nix-shell
    pkgs.asciinema
    pkgs.aspell
    pkgs.awscli
    pkgs.curlFull
    pkgs.direnv
    pkgs.exa
    pkgs.fd
    pkgs.ffmpeg
    pkgs.gitAndTools.diff-so-fancy
    pkgs.gnupg
    pkgs.gradle
    pkgs.graphviz
    pkgs.httpie
    pkgs.hugo
    pkgs.hyperfine
    pkgs.maven
    pkgs.multimarkdown
    pkgs.ncdu
    pkgs.neofetch
    pkgs.niv
    pkgs.nixfmt
    pkgs.neovim
    pkgs.openssl
    pkgs.pandoc
    pkgs.pgcli
    pkgs.prettyping
    pkgs.procs
    pkgs.ranger
    pkgs.readline
    pkgs.ripgrep
    pkgs.rnix-lsp
    pkgs.shellcheck
    pkgs.tealdeer
    pkgs.tig
    pkgs.tokei
    pkgs.tree
    pkgs.wget
    pkgs.xz
  ];
}
