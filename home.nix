{ pkgs, pkg, ... }:

{
  xsession.enable = true;
  xsession.windowManager.command = "spectrwm";

  home.packages = [
    pkgs.htop
    pkgs.tmux
    pkgs.nmap
    pkgs.git
    pkgs.mpv
    pkgs.youtube-dl
    pkgs.firefox
    pkgs.xterm
    pkgs.i3lock
  ];

  home = {
    keyboard.layout = "dvorak";
    file = {
      "repo/mpv-stats".source = (builtins.fetchGit {
        url = "https://github.com/Argon-/mpv-stats/";
        ref = "master";
      });
      ".config/mpv/scripts/stats.lua".source = ~/repo/mpv-stats/stats.lua;

      ".opt/bin/yt-music" = {
        text = ''
          #!/bin/sh
          exec mpv --profile=audio --ytdl-format=bestaudio ytdl://ytsearch:"$*"
        '';
        executable = true;
      };
      ".opt/bin/yt" = {
        text = ''
          #!/bin/sh
          exec xogmpv ytdl://ytsearch:"$*"
        '';
        executable = true;
      };

      ".tmux.conf".text = ''
        bind r source-file ~/.tmux.conf
        set -g status-bg red
        set -g status-fg white
        set -g status-interval 60
        set -g status-left-length 30
        set -g status-left ' '
        set -g status-right '#[fg=black]ld:#(cut -d " " -f 1 /proc/loadavg)#[default] #[fg=black]%H:%M#[default]'
      '';
      ".spectrwm.conf".text = ''
        color_focus = blue
        bar_enabled = 1
        clock_format = %R %d %b %Y %a
        modkey = Mod4
        keyboard_mapping = ~/.spectrwm_mapping.conf
        workspace_limit = 22
        program[lock] = i3lock
      '';
      ".spectrwm_mapping.conf".text = ''
        bind[lock]          = MOD+Shift+Delete
        bind[restart]       = MOD+q
        bind[ws_1]          = MOD+1
        bind[ws_2]          = MOD+2
        bind[ws_3]          = MOD+3
        bind[ws_4]          = MOD+4
        bind[ws_5]          = MOD+5
        bind[ws_6]          = MOD+6
        bind[ws_7]          = MOD+7
        bind[ws_8]          = MOD+8
        bind[ws_9]          = MOD+9
        bind[ws_10]         = MOD+0
        bind[ws_11]         = MOD+F1
        bind[ws_12]         = MOD+F2
        bind[ws_13]         = MOD+F3
        bind[ws_14]         = MOD+F4
        bind[ws_15]         = MOD+F5
        bind[ws_16]         = MOD+F6
        bind[ws_17]         = MOD+F7
        bind[ws_18]         = MOD+F8
        bind[ws_19]         = MOD+F9
        bind[ws_20]         = MOD+F10
        bind[mvws_1]        = MOD+Shift+1
        bind[mvws_2]        = MOD+Shift+2
        bind[mvws_3]        = MOD+Shift+3
        bind[mvws_4]        = MOD+Shift+4
        bind[mvws_5]        = MOD+Shift+5
        bind[mvws_6]        = MOD+Shift+6
        bind[mvws_7]        = MOD+Shift+7
        bind[mvws_8]        = MOD+Shift+8
        bind[mvws_9]        = MOD+Shift+9
        bind[mvws_10]       = MOD+Shift+0
        bind[mvws_11]       = MOD+Shift+F1
        bind[mvws_12]       = MOD+Shift+F2
        bind[mvws_13]       = MOD+Shift+F3
        bind[mvws_14]       = MOD+Shift+F4
        bind[mvws_15]       = MOD+Shift+F5
        bind[mvws_16]       = MOD+Shift+F6
        bind[mvws_17]       = MOD+Shift+F7
        bind[mvws_18]       = MOD+Shift+F8
        bind[mvws_19]       = MOD+Shift+F9
        bind[mvws_20]       = MOD+Shift+F10
        bind[ws_next]       = MOD+Right
        bind[ws_next_all]   = MOD+Up
        bind[ws_prev]       = MOD+Left
        bind[ws_prev_all]   = MOD+Down
        bind[term]          = MOD+Shift+Return
        bind[menu]          = MOD+p
        bind[master_shrink] = MOD+h
        bind[master_grow]   = MOD+l
        bind[iconify]       = MOD+w
      '';
      ".Xresources".text = ''
        XTerm*reverseVideo: off
        xterm*background: black
        xterm*foreground: white
        xterm*metaSendsEscape: true
        xterm*saveLines: 0
      '';
      ".config/mpv/mpv.conf".text = ''
        hwdec=cuda-copy
        fs=yes
        force-window=immediate
        # osc=no #FIXME: Enable it when I found the way to see the time code
        video-sync=display-resample
        user-agent="Mozilla/5.0"
        cache=yes
        demuxer-max-bytes=500M
        demuxer-max-back-bytes=100M
        slang=en
        sub-bold=no
        [anime]
        sharpen=3
        [audio]
        fs=no
        force-window=no
      '';
      ".config/mpv/input.conf".text = ''
      # Reference is input.conf
      e script-binding stats/display-stats
      E script-binding stats/display-stats-toggle
      '';
      ".rtorrent.rc".text = ''
        upload_rate = 1
        directory = ~/.torrent.tmp/
        session = ~/.torrent.tmp/
        #port_random = yes
        check_hash = yes
        dht = auto
        #encryption = allow_incoming,require,require_rc4
      '';
    };
    sessionVariables = {
      EDITOR = "emacs";
      PATH = "$HOME/.opt/bin:$PATH";
    };
  };

  news.display = "silent";

  programs = {
#    autorandr = {
#      enable = true;
#    };
    bash = {
      enable = true;
      historyControl = [ "erasedups"  ];
      historyFile = "~/.my_random_bash_history";
      historyIgnore = [
        "ls"
        "cd"
        "less"
        "exit"
        "home-manager"
        "loadkeys"
        "which"
        "emacs"
        "ping"
        "dig"
        "echo"
      ];
      shellOptions = [ "histappend" ];
    };

    emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    firefox = {
      enable = true;
    };

    git = {
      enable = true;
      userName = "David Moreira";
      userEmail = "dmoreira@gopro.com";
      aliases = {
        l = "log --graph --decorate --all --stat";
        t = "log --graph --decorate --all --stat oneline";
        rb = "rebase";
      };
      extraConfig = {
        core = {
          editor = "emacsclient -t";
        };
        adivce = {
          pushUpdateRejected = false;
        };
      };
      ignores = [
        "*~"
        "*.o"
        "*.a"
        "*.so"
        "*.d"
        "a.out"
        "*.pdf"
        "*.ps"
        "*.midi"
        "*.mid"
        "*.log"
        "*.elc"
      ];
    };
  };

  services = {
    emacs = {
      enable = true;
    };
    redshift = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 5000;
        night = 2300;
      };
    };
    syncthing = {
      enable = true;
    };
  };
}
