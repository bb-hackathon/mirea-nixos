{ config, ... }: let
    layoutDir = "${config.xdg.configHome}/zellij/layouts/";
    defaultTabTemplate = /* kdl */ ''
        default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }
    '';
in {
    xdg.configFile = {
        "${layoutDir}/cli.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="Tab #1 | 󰊠 " focus=true {
                    pane
                }
                tab name="Tab #2 | 󱃽 " {
                    pane
                }
                tab name="Tab #3 | 󰚌 " {
                    pane
                }
            }
        '';
        
        "${layoutDir}/wyrm.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="󱆃 CLI [~]" cwd="~/" focus=true {
                    pane split_direction="vertical" {
                        pane
                        pane cwd="Aeon/"
                    }
                }

                tab name="󰍳 Subliminal | 󰡨 " cwd="~/Repos/Subliminal" {
                    pane split_direction="horizontal" {
                        pane split_direction="vertical" {
                            pane size="50%"
                            pane edit="./docker-compose.yml"
                        }
                        pane size="40%" {
                            command "docker"
                            args "compose" "logs" "--follow"
                        }
                    }
                }

                tab name="󱄅 System Monitor" cwd="/" {
                    pane split_direction="horizontal" {
                        pane size="70%" {
                            command "btm"
                            args "--battery"
                        }
                        pane
                    }
                }
            }
        '';

        "${layoutDir}/monocle.kdl".text = /* kdl */ ''
            layout {
                ${defaultTabTemplate}
                tab name="Monocle | 󰹻 " focus=true {
                    pane split_direction="horizontal" {
                        pane size="70%" edit="./"
                        pane
                    }
                }
            }
        '';
    };
}
