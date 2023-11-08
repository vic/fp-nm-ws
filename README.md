# fp-nm-ws: FlakeParts NixosModule WithSystem'

This flake provides a [flake-parts](https://flake.parts) module
that allows nixos-modules to access [perSystem](https://flake.parts/module-arguments#withsystem) [module parameters](https://flake.parts/module-arguments#persystem-module-parameters) without having to rely on global variables.


Mixing the provided `nixosModules.default` module, will provide you
with `withSystem'`, `self'`, and `inputs'` to your other nixos modules.

### Example Usage


```nix
# flake.nix
{
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.fp-nm-ws.url = "github:vic/fp-nm-ws";
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./your-flake-module.nix;
}
```


```nix
# your-flake-module.nix
{inputs, ...}: {
  perSystem = {system, ...}: {
    config._module.args.foo = "moo-${system}"; # suppose you have a per-system module argument named foo.
    options.bar.default = "some per-system option";
  };

  flake.nixosModules.your-nixos-module.imports = [
    inputs.fp-nm-ws.nixosModules.default # mix-in along with your nixos module.
    ./your-nixos-module.nix
  ];

}
```


```nix
# your-nixos-module.nix
{ config, lib, withSystem', inputs', ...}: {

  # an example usage is reusing the same nixpkgs instance.
  nixpkgs.pkgs = inputs'.nixpkgs.legacyPackages;

  accessFoo = withSystem' ({foo, ...}: foo); # use named parameters
  accessBar = withSystem' (sys@{config, ...}: sys.config.bar);

}
```

