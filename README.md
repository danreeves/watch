# ![watch](./head.png)

**Watch your files and run commands on changes from a crystal script**

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     watch:
       github: danreeves/watch
   ```

2. Run `shards install`

## Usage

Create a crystal file to be your task manager, something like `watch.cr`

```crystal
require "watch"

Watch.watch "./src/**/*.cr", "crystal build src/main.cr"
Watch.watch "./*", "echo \"wow a file changed\"", opts: [:verbose, :log_changes]
Watch.run
```

Now you can run it with `crystal watch.cr` and rebuild your main application whenever a file changes. Useful for webservers like Kemal!

Every `Watch.watch` command is run in it's own Fiber so you can have multiple tasks running different commands while watching different files.

### `Watch.watch(glob: String, command: String, opts: [], interval: Int32)`

`watch` takes a glob of files to watch and a command to run. Configuration is provided by `opts` and includes:
  - `:on_start`: Run the command immediately as well as on file changes
  - `:log_changes`: Print a message when a file changes
  - `:verbose`: Increases the verbosity of the message to includes how many files changed and whether they were new files, deletions, or changes.

### `Watch.run`

*Required* to be called at the end of your watch script

## Contributing

1. Fork it (<https://github.com/danreeves/watch/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dan Reeves](https://github.com/danreeves) - creator and maintainer
