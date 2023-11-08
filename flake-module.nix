{ withSystem, ... }: let
  nixosModule = {config, ...}: let
    withSystem' = withSystem config.nixpkgs.hostPlatform.system;
  in {
    _module.args = {
      inherit withSystem';
      self' = withSystem' ({self', ...}: self');
      inputs' = withSystem' ({inputs', ...}: inputs');
    };
  };
in {
  flake.nixosModules.default = nixosModule;
}
