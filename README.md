
# Context

[![Build and Test](https://github.com/c-cube/ocaml-context/actions/workflows/main.yml/badge.svg)](https://github.com/c-cube/ocaml-context/actions/workflows/main.yml)

[documentation](https://c-cube.github.io/ocaml-context/)

`context` is a immutable context to carry around in the processing of a
network request, or any other asynchronous task. It can carry around
cross-cutting concerns such as deadlines, tracing information, timing
information, debugging tags, etc.

At its core, a `Context.t` is a heterogeneous map, either custom or
an alias to [hmap](https://github.com/dbuenzli/hmap) if installed,
alongside a set of standard **keys**.
Each key provides access to some specific information (deadline, timing information, etc.)

The hope is that this can be a lightweight dependency for projects that
need to carry this kind of information around, and to help standardize _keys_.
[Context] relies on
[dune's alternative dependencies](https://dune.readthedocs.io/en/stable/reference/library-dependencies.html#alternative-dependencies)
to use optional dependencies for standard keys, instead of hard dependencies.

## License

MIT
