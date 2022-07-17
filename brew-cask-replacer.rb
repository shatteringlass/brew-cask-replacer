#!/usr/bin/env ruby
require 'fileutils'

# Array of installed applications to exclude. Ex: Firefox Beta
# exclude = ["firefox"]
exclude = []

Dir.glob('/Applications/*.app').each do |path|
  next if File.symlink?(path)

  # Remove version numbers at the end of the name
  app = path.slice(14..-1).sub(/.app\z/, '').sub(/ \d*\z/, '')
  searchresult = `brew search #{app}`
  puts searchresult

  next unless searchresult =~ /Exact match/

  token = searchresult.split("\n")[1]

  next unless exclude.grep(/#{token}/).empty?

  puts "Installing #{token}..."
  begin
    puts "Skipping app deletion..."
    # FileUtils.mv(path, File.expand_path('~/.Trash/'))
  rescue Errno::EPERM, Errno::EEXIST
    puts "ERROR: Could not move #{path} to Trash"
    next
  end
  File.write('Brewfile', 'cask "#{token}"', mode: 'a+')
  #puts `brew install --cask #{token} $(echo $HOMEBREW_CASK_OPTS)`
end
