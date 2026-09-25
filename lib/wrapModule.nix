# Wraps a NixOS module path so extra arguments (flake-local packages/lib
# values that aren't part of specialArgs) get merged in before evaluation.
extraArgs: module: args: import module (args // extraArgs)
