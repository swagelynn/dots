{
  description = "meow... meowwwwwwwwww.... :3";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:swagelynn/stylix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    ...
  }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # substitute

        modules = [
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          ({
              self,
              pkgs,
              lib,
              config,
              ...
            }:
            # main system conf
            {
              system = {
                stateVersion = "25.05";
              };

              time = {
                timeZone = "Europe/London";
              };

              boot = {
                loader = {
                  systemd-boot = {
                    enable = true;
                  };
                  efi = {
                    canTouchEfiVariables = true;
                  };
                };
              };

              nix = {
                settings = {
                  experimental-features = ["nix-command" "flakes" "recursive-nix"];
                  trusted-users = ["maddie" "root"];

                  substitute = true;
                  cores = 12;
                  trusted-substituters = [
                    "https://cache.nixos.org/"

                    "https://cache.nixos-cuda.org"
                    "https://chaotic-nyx.cachix.org"
                    "https://nix-community.cachix.org"
                    "https://cache.garnix.io"
                    "https://cache.flox.dev"
                  ];
                  trusted-public-keys = [
                    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                    "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M"
                    "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
                  ];
                };
              };

              nixpkgs = {
                config = {
                  allowUnfree = true;
                  cudaSupport = true;
                  permittedInsecurePackages = ["electron-36.9.5"];
                };
                hostPlatform = "x86_64-linux";
              };

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                sharedModules = [
                  stylix.homeModules.stylix
                ];

                users = {
                  maddie = {
                    config,
                    pkgs,
                    inputs,
                    lib,
                    ...
                  }: {
                    wayland.windowManager.hyprland = {
                      enable = true;
                      extraConfig = builtins.readFile /home/maddie/nixos/config/hypr/hyprland.conf;
                    };
                    home = {
                      username = "maddie";
                      homeDirectory = "/home/maddie";
                      stateVersion = "25.11";
                      file = {
                        # config
                        #xdg.configFile.".config/hypr".source = ./config/hyprland;
                        ".config/gotify-desktop".source = /home/maddie/nixos/config/gotify;
                        # ".config/hypr/hyprland.conf".source = /home/maddie/nixos/config/hypr/hyprland.conf;

                        # data
                        #".config/heroic".source = config.lib.file.mkOutOfStoreSymlink /home/maddie/nixos/data/heroic;
                        #".config/VSCodium".source = config.lib.file.mkOutOfStoreSymlink /home/maddie/nixos/data/vscodium;
                      };

                      pointerCursor = {
                        gtk.enable = true;
                        x11.enable = true;
                        package = pkgs.catppuccin-cursors.mochaDark;
                        name = "catppuccin-mocha-dark-cursors";
                        size = 24;
                      };
                    };

                    stylix = {
                      enable = true;
                      autoEnable = true;
                      base16Scheme = "/home/maddie/Downloads/maddie.yaml";
                      image = /run/media/maddie/storage/Walls/mono.jpg;

                      targets = {
                        gtk.enable = true;
                        nixcord.enable = false;
                        vscode.enable = true;

                        hyprland = {
                          enable = true;
                          colors.enable = true;
                          hyprpaper.enable = true;
                          image.enable = true;
                        };

                        hyprpaper.enable = true;

                        kitty = {
                          enable = true;
                          colors.enable = true;
                        };

                        vesktop = {
                          enable = true;
                          colors.enable = true;
                          fonts.enable = true;
                        };
                        firefox = {
                          enable = true;
                          profileNames = ["default"];
                          colorTheme.enable = true;
                        };
                      };

                      fonts = {
                        sansSerif = {
                          name = "ComicShannsMono Nerd Font Mono";
                          package = pkgs.nerd-fonts.comic-shanns-mono;
                        };
                        monospace = {
                          name = "ComicShannsMono Nerd Font Mono";
                          package = pkgs.nerd-fonts.comic-shanns-mono;
                        };
                        serif = {
                          name = "ComicShannsMono Nerd Font Mono";
                          package = pkgs.nerd-fonts.comic-shanns-mono;
                        };
                      };
                    };

                    gtk = {
                      enable = true;

                      cursorTheme = {
                        package = pkgs.catppuccin-cursors.mochaDark;
                        name = "Catppuccin Mocha Dark";
                      };
                    };

                    programs = {
                      kitty = {
                        enable = true;
                        extraConfig = ''
                          confirm_os_window_close 0
                          background_opacity 1
                          background_blur 0
                          window_padding_width 4 4 4 8
                        '';
                      };
                      obs-studio = {
                        enable = true;
                        plugins = [
                          pkgs.obs-studio-plugins.wlrobs
                        ];
                      };
                      vesktop.enable = true;

                      hyprpanel = {
                        enable = true;
                        settings = {
                          bar = {
                            workspaces.show_numbered = true;

                            theme.bar = {
                              transparent = true;
                              opacity = 0;
                            };

                            launcher.autoDetectIcon = true;

                            layouts = {
                              "*" = {
                                left = [
                                  "workspaces"
                                ];

                                middle = ["media"];

                                right = [
                                  "volume"
                                  "bluetooth"
                                  "systray"
                                  "notifications"
                                  "clock"
                                ];
                              };
                            };
                          };

                          menus.dashboard = {
                            powermenu = {
                              avatar.image = "/home/maddie/pfp.jpg";
                              reboot = ":";
                              sleep = ":";
                              shutdown = ":";
                              logout = ":";
                              enabled = false;
                            };

                            stats.enabled = true;
                            shortcuts.enabled = false;
                            directories.enabled = false;
                          };
                        };
                      };

                      btop = {
                        enable = true;
                        settings = {
                          color_theme = "stylix";
                          theme_background = false;
                        };
                      };

                      wofi = {
                        enable = true;
                      };

                      vscode = {
                        enable = true;
                        package = pkgs.vscodium;
                        mutableExtensionsDir = true;
                        profiles = {
                          default = {
                            extensions = [
                              # pkgs.vscode-extensions.catppuccin.catppuccin-vsc
                            ];
                            userSettings = {
                              # "workbench.colorTheme" = "Catppuccin Mocha";
                              "nix.enableLanguageServer" = true;
                            };
                          };
                        };
                      };

                      firefox = {
                        enable = true;
                        profiles = {
                          default = {
                            id = 0;
                            name = "default";
                            isDefault = true;
                            settings = {
                              # search

                              "browser.search.defaultenginename" = "DuckDuckGo";
                              "browser.urlbar.suggest.searches" = false;
                              "browser.urlbar.suggest.recentsearches" = false;

                              # font config
                              "font.name.monospace.x-western" = lib.mkForce "ComicShannsMono Nerd Font Mono";
                              "font.name.sans-serif.x-western" = lib.mkForce "ComicShannsMono Nerd Font Mono";
                              "font.name.serif.x-western" = lib.mkForce "ComicShannsMono Nerd Font Mono";
                              "browser.display.use_document_fonts" = 0;

                              policies = {
                                DisableTelemetry = true;
                                DisableFirefoxStudies = true;
                              };
                            };
                            extensions = {
                              force = true;
                              settings."uBlock0@raymondhill.net".settings = {
                                selectedFilterLists = [
                                  "ublock-filters"
                                  "ublock-badware"
                                  "ublock-privacy"
                                  "easylist"
                                ];
                              };
                            };
                            bookmarks = {
                              force = true;
                              settings = [];
                            };
                          };
                        };
                      };
                    };
                    #
                    dconf = {
                      settings = {
                        "org/cinnamon/desktop/applications/terminal" = {
                          exec = "kitty";
                          exec-arg = "-e";
                        };
                        "org/cinnamon/desktop/default-applications/terminal" = {
                          exec = "kitty";
                          exec-arg = "-e";
                        };
                        "org/gnome/desktop/interface".font-name = lib.mkForce "ComicShannsMono Nerd Font Mono";
                      };
                    };

                    services = {
                      udiskie = {
                        enable = true;
                        settings = {
                          # workaround for
                          # https://github.com/nix-community/home-manager/issues/632
                          program_options = {
                            file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
                          };
                        };
                      };
                      hyprpaper.enable = true;
                      easyeffects = {
                        enable = true;
                      };
                    };
                  };
                };
              };

              users = {
                users = {
                  maddie = {
                    isNormalUser = true;
                    extraGroups = ["wheel" "docker"];
                    uid = 1000;
                  };
                };
              };

              programs = {
                hyprland.enable = true;
                obs-studio = {
                  enable = true;
                };
                light = {
                  enable = true;
                };
                steam = {
                  enable = true;
                };
                gamemode = {
                  enable = true;
                };
                dconf = {
                  enable = true;
                };
                nix-ld = {
                  enable = true;
                };
              };

              services = {
                xserver.videoDrivers = ["nvidia"];
                openssh = {
                  enable = true;
                };
                displayManager.ly.enable = true;
                pipewire = {
                  enable = true;
                  alsa.enable = true;
                  alsa.support32Bit = true;
                  pulse.enable = true;
                  jack.enable = true;

                  extraConfig = {
                    pipewire."92-low-latency" = {
                      context.properties = {
                        "default.clock.rate" = 96000;
                        "default.clock.allowed-rates" = [96000 48000 44100];
                        "default.clock.quantum" = 32;
                        "default.clock.min-quantum" = 32;
                        "default.clock.max-quantum" = 32;
                      };
                    };
                  };
                };

                tlp = {
                  enable = true;
                  settings = {
                    CPU_SCALING_GOVERNOR_ON_AC = "performance";
                    CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
                  };
                };

                udisks2 = {
                  enable = true;
                };

                blueman = {
                  enable = true;
                };
              };

              powerManagement = {
                cpuFreqGovernor = "schedutil";
                cpufreq = {
                  min = 800000;
                  max = null;
                };
              };

              fonts = {
                fontconfig = {
                  enable = true;
                  defaultFonts = {
                    serif = ["ComicShannsMono Nerd Font Mono"];
                    sansSerif = ["ComicShannsMono Nerd Font Mono"];
                    monospace = ["ComicShannsMono Nerd Font Mono"];
                    emoji = ["Twitter Color Emoji"];
                  };
                };

                packages = with pkgs; [
                  twemoji-color-font
                  twitter-color-emoji
                  nerd-fonts.monaspace
                  nerd-fonts.comic-shanns-mono
                  monaspace
                ];
              };

              boot = {
                initrd = {
                  availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
                  kernelModules = ["kvm-intel" "kvm-amd"];
                };
                kernelParams = [
                  "iommu=pt"
                  "amd_iommu=on"
                  "vfio-pci.ids=10de:1e81,10de:10f8,10de:1ad8,10de:1ad9"
                ];
                kernelModules = ["kvm-amd"];
                extraModulePackages = [];
              };

              fileSystems = {
                "/" = {
                  device = "/dev/disk/by-uuid/18080625-7be6-4e09-8671-8f426c6f4dc1";
                  fsType = "ext4";
                };
                "/run/media/maddie/media" = {
                  device = "/dev/sdb1";
                  fsType = "ext4";
                  options = ["defaults" "x-gvfs-name=Media"];
                };
                "/run/media/maddie/storage" = {
                  device = "/dev/nvme0n1p1";
                  fsType = "ext4";
                  options = ["defaults" "x-gvfs-name=Storage"];
                };
                "/run/media/maddie/games" = {
                  device = "/dev/sda1";
                  fsType = "ext4";
                  options = ["defaults" "x-gvfs-name=Games"];
                };
                "/boot" = {
                  device = "/dev/disk/by-uuid/E571-9DDF";
                  fsType = "vfat";
                  options = ["fmask=0022" "dmask=0022"];
                };
              };
              swapDevices = [
                {
                  device = "/var/lib/swapfile";
                  size = 16 * 1024; # 16 GB
                }
              ];

              hardware = {
                nvidia-container-toolkit.enable = true;
                nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
                nvidia.open = true;
                graphics.enable = true;
                graphics.enable32Bit = true;
                bluetooth = {
                  enable = true;
                  powerOnBoot = true;
                  settings = {
                    General = {
                      Experimental = true;
                    };
                  };
                };
              };

              networking = {
                useDHCP = lib.mkForce true;
                networkmanager = {
                  enable = true;
                };
                firewall = {
                  enable = false;
                };
                hostName = "nixos";
              };

              virtualisation = {
                docker = {
                  enable = true;
                };
              };

              security = {
                sudo = {
                  extraRules = [
                    {
                      users = ["maddie"];
                      commands = [
                        {
                          command = "ALL";
                          options = ["NOPASSWD"];
                        }
                      ];
                    }
                  ];
                };
              };
            })
          # packages
          ({
            self,
            pkgs,
            ...
          }: {
            environment = {
              systemPackages = with pkgs; [
                docker-compose
                tree
                fastfetch
                protonup-ng
                btop
                unzip
                jq
                smartmontools
                # sgdboop
                yt-dlp
                speedtest-cli
                p7zip
                file
                ffmpeg
                xorg.libX11
                alejandra
                playerctl
                cairo
                fuse
                gvfs
                fuse3
                wl-clipboard
                immich-cli
                cinnamon-common
                icu
                ddcutil
                osu-lazer-bin
                r2modman
                azahar
                # olympus
                heroic
                gamescope
                tela-icon-theme
                catppuccin-cursors.mochaDark
                magnetic-catppuccin-gtk
                git
                gh
                nodejs
                pnpm
                bun
                go
                dotnet-sdk_9
                mono
                rustc
                cargo
                rustfmt
                clippy
                rust-analyzer
                gcc
                gnumake
                nim
                nimble
                opencl-headers
                kitty
                pavucontrol
                nemo-with-extensions
                nemo-fileroller
                gnome-system-monitor
                vlc
                hyprshot
                hyprsunset
                hyprpicker
                hyprpolkitagent
                eog
                baobab
                video-trimmer
                delfin
                catppuccinifier-cli
                blueberry
                gimp3
                mpv
                tenacity
                wine
                wine64
                foliate
                udiskie
                bottles
                cudatoolkit
                nv-codec-headers
                dino
                emote
                # blender
                hyprland
                direnv
                nil
                swaybg
                hyprlauncher
                vesktop
                wofi
                hyprpaper
              ];
            };
          })
        ];
      };
    };
  };
}
