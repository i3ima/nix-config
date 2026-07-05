final: prev:
{
  freeswitch = prev.freeswitch.override {
    callPackage = fn: args: prev.callPackage fn (args // { lua = prev.lua5_3; });
  };
}
