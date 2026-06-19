{
  config,
  lib,
  pkgs-list,
  parentPathAsList,
  tools,
  ...
}: let
  moduleParams = tools.moduleParams rec {
    inherit config lib pkgs-list parentPathAsList tools;
    name = "vscode";
    main-repo = "nix";
    branch = "unstable";
    options = {
      enable = lib.mkEnableOption "Enables ${name} program and related settings.";
    };
    extras = {
    };
  };
  # TODO : Needs to be configured (profiles.defaults)
in (tools.fullModule rec {
  inherit (moduleParams) config lib pkgs-list parentPathAsList tools;
  inherit (moduleParams) name togglable subfolder main-repo branch extras imports specialImports options settings;
  inherit (moduleParams) packages currentPathAsList currentDirPath cfg inheritedSettings Common;
  Home = {
    programs.vscode = {
      enable = true;
      package = packages.vscode;
      mutableExtensionsDir = false;
      profiles.default = {
        enableExtensionUpdateCheck = true;
        enableUpdateCheck = true;
        keybindings = [
          {
            command = "workbench.action.quit";
            key = "ctrl+shit+q";
          }
          {
            command = "-workbench.action.quit";
            key = "ctrl+q";
          }
        ];
        userSettings =
          {
            "http.proxySupport" = "off";
            "security.workspace.trust.untrustedFiles" = "open";

            "window.newWindowProfile" = "Default";
            "workbench.colorTheme" = "Dark Modern";
            "window.zoomLevel" = -1;
            "editor.minimap.enabled" = false;

            "diffEditor.ignoreTrimWhitespace" = true;

            "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
            "terminal.integrated.fontSize" = 15;
            "terminal.integrated.gpuAcceleration" = "off";
            "terminal.integrated.fontLigatures.enabled" = true;

            "github.copilot.nextEditSuggestions.enabled" = true;
            "github.copilot.enable" = {
              "*" = true;
              "plaintext" = true;
              "markdown" = true;
              "scminput" = false;
            };
            "chat.tips.enabled" = false;

            "[perl]" = {
              "editor.tabSize" = 2;
              "editor.insertSpaces" = true;
            };
          }
          // (
            tools.ifEnabled config "config.progs.dev.lang.nix" {
            }
            // (
              tools.ifEnabled config "config.progs.dev.lang.nix.nil" {
                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nil";
              }
              // (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" {
                "nix.serverSettings" = {
                  "nil" = {
                    "formatting" = {
                      "command" = [
                        "alejandra"
                      ];
                    };
                  };
                };
              })
            )
            // (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" {
              "[nix]" = {
                "editor.defaultFormatter" = "kamadorueda.alejandra";
                "editor.formatOnPaste" = false;
                "editor.formatOnSave" = false;
                "editor.formatOnType" = false;
              };
              "nix.formatterPath" = "alejandra";
              "alejandra.program" = "alejandra";
            })
          )
          // (tools.ifEnabled config "config.progs.dev.lang.python" {
            "python.analysis.typeCheckingMode" = "standard";
          })
          // (tools.ifEnabled config "config.progs.dev.lang.latex" {
            "latex-workshop.latex.recipe.default" = "first";
            "latex-workshop.latex.clean.command" = "latexmk";
            "latex-workshop.latex.recipes" = [
              {
                "name" = "latexmk (xelatex)";
                "tools" = [
                  "xelatexmk"
                ];
              }
              {
                "name" = "latexmk (lualatex)";
                "tools" = [
                  "lualatexmk"
                ];
              }
              {
                "name" = "latexmk";
                "tools" = [
                  "latexmk"
                ];
              }
              {
                "name" = "latexmk (latexmkrc)";
                "tools" = [
                  "latexmk_rconly"
                ];
              }
              {
                "name" = "pdflatex -> bibtex -> pdflatex * 2";
                "tools" = [
                  "pdflatex"
                  "bibtex"
                  "pdflatex"
                  "pdflatex"
                ];
              }
              {
                "name" = "Compile Rnw files";
                "tools" = [
                  "rnw2tex"
                ];
              }
              {
                "name" = "Compile Jnw files";
                "tools" = [
                  "jnw2tex"
                ];
              }
              {
                "name" = "Compile Pnw files";
                "tools" = [
                  "pnw2tex"
                ];
              }
              {
                "name" = "tectonic";
                "tools" = [
                  "tectonic"
                ];
              }
            ];
            "latex-workshop.formatting.latex" = "tex-fmt";
          });
      };
    };

    home.activation = {
      "${name}_settings" = let
        config_path = "${config.xdg.configHome}/Code/User";
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p ${config_path}
          rm -f ${config_path}/settings.json ${config_path}/keybindings.json
          cp $newGenPath/home-files/.config/Code/User/settings.json ${config_path}/settings.json
          cp $newGenPath/home-files/.config/Code/User/keybindings.json ${config_path}/keybindings.json
          chmod 644 ${config_path}/settings.json ${config_path}/keybindings.json
        '';
    };
  };
})
