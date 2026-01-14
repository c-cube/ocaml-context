(lang dune 2.9)

(name context)
(version 0.1)
(generate_opam_files true)
(source
 (github c-cube/ocaml-context))
(authors "Simon Cruanes")
(maintainers "Simon Cruanes")
(license MIT)

(package
 (name context)
 (synopsis "Generic request handling context to carry around, inspired from Go's")
 (depends
  (ocaml (>= 4.08))
  (dune (>= 2.9))
  (odoc :with-doc))
 (depopts
   hmap
   mtime)
 (conflicts (thread-local-storage (< 0.2)))
 (tags
  (context)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
