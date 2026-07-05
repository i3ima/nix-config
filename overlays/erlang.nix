final: prev:
let
  erlangNoWx = prev.beam.interpreters.erlang.overrideAttrs (
old: {
    configureFlags = (old.configureFlags or []) ++ [ "--with
out-wx" ];
    buildInputs = builtins.filter
      (dep: !(builtins.elem (dep.pname or "") [ "wxGTK" "wxG
TK32" "wxwidgets" ]))
      (old.buildInputs or []);
  });
in {
  erlang-no-wx = erlangNoWx;
  rebar3-no-wx = (prev.beam.packagesWith erlangNoWx).rebar3;
}

