require "spec"
require "process"
require "../src/watch"

def wait_until(stdout : IO::Memory, output : String)
  timeout = Time.utc + 5.seconds
  while true
    sleep 1.millisecond
    break if Time.utc >= timeout
    break if stdout.to_s.includes?(output)
  end
  stdout.to_s.should contain(output)
end

class Running
  @process : Process
  @stdout : IO::Memory
  @stderr : IO::Memory

  def initialize(process : Process, stdout : IO::Memory, stderr : IO::Memory)
    @process = process
    @stdout = stdout
    @stderr = stderr
  end

  def wait_until_stdout(output : String)
    wait_until @stdout, output
  end

  def wait_until_stderr(output : String)
    wait_until @stderr, output
  end

  def clear_stdout
    @stdout.clear
  end

  def clear_stderr
    @stderr.clear
  end
end

def run(name : String, &block)
  stdout = IO::Memory.new
  stderr = IO::Memory.new
  command = "crystal"
  args = "run spec/specs/#{name}/watch.cr"
  process = Process.new(command, args.split(" "), output: stdout, error: stderr)

  running = Running.new process, stdout, stderr

  with running yield
  process.signal(Signal::INT)
end
