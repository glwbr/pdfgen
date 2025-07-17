{
  description = "PDFGen with typst because LaTeX is too much for me ";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/f62d6734af4581af614cab0f2aa16bcecfc33c11";

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
      # TODO: I think we can move this to callPackage
      mgPackage = { pkgs }: pkgs.writeShellScriptBin "mg" ''
        if [ -z "$1" ]; then
          echo "Error: Please provide a migration name"
          echo "Usage: mg <migration_name>"
          exit 1
        fi

        ${pkgs.go-migrate}/bin/migrate create -ext sql -dir ./db/migrations -tz UTC "$1"
      '';
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildGoModule {
            pname = "pdfgen";
            version = "alpha";
            src = ./.;
            vendorHash = "sha256-s1LsDR/Q30lZObKOldxFf627GNHzG2pYJGrAQsCxAeQ=";
            meta = with pkgs.lib; {
              description = "Library / API for generating PDF documents using typst";
              homepage = "https://github.com/glwbr/pdfgen";
              license = licenses.mit;
              mainProgram = "pdfgen";
            };
          };

          mg = mgPackage { inherit pkgs; };
        }
      );

      devShells = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
          {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
              yarn
              go go-migrate treefmt typst sqlc go-swag air
              self.packages.${system}.mg
            ];
            shellHook = ''
              export DATABASE_URL=postgres://admin:admin@localhost:5432/pdfgen?sslmode=disable
              export PORT=8081
              export CGO_ENABLED=0
              echo "Run 'air' for auto-recompilation"
              echo "Run 'mg <name>' to create migrations"
              echo "Run 'sqlc generate' to create the needed queries and models"
              '';
          };
        }
      );

      apps = forEachSystem (system: {
        default = {
          type = "app";
          program = "${nixpkgs.legacyPackages.${system}.lib.getExe self.packages.${system}.default}";
        };
      });

      defaultPackage = forEachSystem (system: self.packages.${system}.default);
      defaultApp = forEachSystem (system: self.apps.${system}.default);
    };
}
