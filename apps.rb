#!/usr/bin/env ruby

require "yaml"

# Prompt install
puts "Which apps do you want to install?"
puts " [1] core (default)"
puts " [2] work"
puts " [3] personal"
type = gets.chomp

# Installation list
installs = %w(customization development)
case type
when "2" then installs << "work"
when "3" then installs << "personal"
end

# Install lists
commands = {
  "bash" => "sh -c",
  "brew" => "brew install",
  "cask" => "brew cask install",
  "npm"  => "npm install"
}

installs.each do |install|
  install = YAML.load_file(File.expand_path("../apps/#{install}.yml", __FILE__))

  install.each do |install_type, install_list|
    if install_type == "store"
      puts ""
      puts "The following will have to be installed manually:"
      puts "================================================="
      puts install_list
    end

    install_list.each do |program|
      command = "#{commands[install_type]} '#{program}'"
      puts ""
      puts "Installing: #{command}"
      puts system(command) ? "Done!" : "Failed..."
    end
  end
end
