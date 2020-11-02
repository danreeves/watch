require "../../../src/watch"

Watch.watch "./spec/specs/initial/*", "echo yup", opts: [:on_start]
Watch.run
