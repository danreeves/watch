# watch

Watch your files and run commands on changes from a crystal script

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     watch:
       github: danreeves/watch
   ```

2. Run `shards install`

## Usage

```crystal
require "watch"

Watch.watch "./src/**/*.cr", "crystal build src/main.cr"
Watch.watch "./*", "echo \"wow a file changed\"", opts: [:verbose, :log_changes]
Watch.run
```

TODO: Write usage instructions here

## Contributing

1. Fork it (<https://github.com/danreeves/watch/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dan Reeves](https://github.com/danreeves) - creator and maintainer
