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

        extensions = with packages.vscode-extensions;
          [
            github.vscode-github-actions
            github.vscode-pull-request-github

            ms-vscode-remote.remote-containers
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode.remote-explorer
          ]
          ++ [
            pkgs-list.others.dev.vscode-extensions.vscode-extensions.danielatanasov.todo
            pkgs-list.others.dev.vscode-extensions.vscode-extensions.prateekmahendrakar.prettyxml
            pkgs-list.others.dev.vscode-extensions.vscode-extensions.zhiyuan-lin.simple-perl
          ]
          ++ (tools.ifEnabled config "config.progs.shells.direnv" [
            mkhl.direnv
          ])
          ++ [
            gruntfuggly.todo-tree
            jgclark.vscode-todo-highlight
            tomoki1207.pdf
          ]
          ++ (tools.ifEnabled config "config.progs.dev.lang.nix" [
            arrterian.nix-env-selector
            bbenoist.nix
            jnoortheen.nix-ide
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.nix.alejandra" [
            kamadorueda.alejandra
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.python" [
            ms-python.debugpy
            ms-python.python
            ms-python.vscode-pylance
          ])
          ++ (tools.ifEnabled config "config.progs.dev.lang.latex" [
            james-yu.latex-workshop
          ])
          ++ [
            tamasfe.even-better-toml
          ];
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
      # "${name}_extensions" = let
      #   extensions_path = "$HOME/.vscode/extensions";
      #   extensions_editable_path = "$HOME/.vscode/extensions-editable";
      # in
      #   lib.hm.dag.entryAfter ["writeBoundary"] ''
      #     mkdir -p ${extensions_editable_path}
      #     cp -r $newGenPath/home-files/.vscode/extensions/* ${extensions_editable_path}/
      #     rm -f ${extensions_editable_path}/extensions.json
      #     cp $newGenPath/home-files/.vscode/extensions/extensions.json ${extensions_editable_path}/extensions.json
      #     chmod 644 ${extensions_editable_path}/extensions.json
      #     chmod 755 ${extensions_editable_path}
      #     rm -rf ${extensions_path}
      #     mv ${extensions_editable_path} ${extensions_path}
      #   '';
    };
  };
})
