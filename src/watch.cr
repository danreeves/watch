require "file"
require "process"
require "colorize"

module Watch
  VERSION = "1.0.1"

  private def self.children_of(pid : Int64)
    pids = [pid] of Int64
    output = `ps ao pid,ppid`.split('\n')
    output.delete_at(0)
    output = output.map do |line|
      line.split(' ').map do |col|
        col.strip
      end
        .reject do |col|
          col.blank?
        end
    end
      .reject do |row|
        row.empty?
      end
      .each do |row|
        if pids.includes?(row[1].to_i64)
          pids << row[0].to_i64
        end
      end

    return pids
  end

  def self.watch(glob, full_command, opts = [] of Symbol, interval = 0.1)
    spawn do
      files = Dir.glob(glob).to_set
      timestamps = {} of String => Time
      command_parts = full_command.split(" ")
      command = command_parts[0]
      args = command_parts[1, full_command.size]

      stdout = IO::Memory.new
      process = nil
      if opts.includes?(:on_start)
        puts "> running \"#{command} #{args.join(" ")}\"".colorize(:green)
        process = Process.new(command, args, output: stdout, error: stdout)
      end

      # Collect the list of current files watched
      files.each do |file|
        timestamps[file] = File.info(file).modification_time
      end

      loop do
        files_added = [] of String
        files_changed = [] of String
        files_removed = [] of String

        # If there is stdout then print it and clear the buffer
        output = stdout.to_s
        if output.size > 0
          puts output
          stdout.clear
        end

        # Update added and removed files
        current_files = Dir.glob(glob).to_set
        deleted_or_renamed_files = files.dup.subtract(current_files)
        added_or_renamed_files = current_files.dup.subtract(files)

        added_or_renamed_files.each do |file|
          if !files.includes?(file)
            files.add(file)
            files_added << file
          end
          timestamps[file] = File.info(file).modification_time
        end

        deleted_or_renamed_files.each do |file|
          if files.includes?(file)
            files.delete(file)
          end
          timestamps.delete(file)
          files_removed << file
        end

        files.each do |file|
          time = File.info(file).modification_time
          if time != timestamps[file]
            files_changed << file
            timestamps[file] = time
          end
        end

        all_changed = files_added.dup.concat(files_changed).concat(files_removed)
        if all_changed.size > 0
          if opts.includes?(:log_changes)
            if opts.includes?(:verbose)
              added = "+#{files_added.size}".colorize(:green)
              changed = "~#{files_changed.size}".colorize(:yellow)
              removed = "-#{files_removed.size}".colorize(:red)
              diff = [added, changed, removed].join(", ")
              puts ">> #{diff}"
            else
              puts ">> #{all_changed.size} changes".colorize(:yellow)
            end
          end

          if process && !process.terminated?
            children_of(process.pid).each do |pid|
              Process.signal(Signal::INT, pid)
            end
          end

          puts "> running \"#{command} #{args.join(" ")}\"".colorize(:green)
          process = Process.new(command, args, output: stdout, error: stdout)
        end

        sleep interval
      end
    end
  end

  def self.run
    return sleep
  end
end
