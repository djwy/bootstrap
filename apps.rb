#!/usr/bin/env ruby

require "pty"
require "yaml"

module Exec
  module_function

  def cmd(*args)
    PTY.spawn(args.join(" ")) do |stdout, _stdin, _pid|
      begin
        stdout.each(&method(:puts))
      rescue Errno::EIO; puts "..."
      end
    end
  rescue PTY::ChildExited
    puts "Done!"
  end

  def bash(*args)
    cmd(args.join("; "))
  end

  def brew(*args)
    cmd(*%w(brew install), *args)
  end

  def cask(*args)
    cmd(*%w(brew cask install), *args)
  end

  def store(*args)
    unless @flag_done
      puts "\nThe following need to be installed manually"
      @flag_done = true
    end
    puts *args
  end

  def npm(*args)
    cmd(*%w(npm install -g), *args)
  end
end

module AppGroup
  module_function

  def run(name)
    puts "Installing #{name} apps"
    yaml(name).each { |key, vals| vals.each { |v| Exec.send(key, v) } }
  end

  def yaml(name)
    YAML.load_file(File.expand_path("../apps/#{name}.yaml", __FILE__))
  end
end

essentials = %w(core customization development)
case ARGV[0]
when "core" then AppGroup.run("core")
when "work" then (essentials + ["work"]).each(&AppGroup.method(:run))
else (essentials + ["personal"]).each(&AppGroup.method(:run))
end
