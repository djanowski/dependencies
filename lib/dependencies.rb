# Copyright 2009 Damian Janowski. MIT License.
# http://gist.github.com/100655
#
# Very simple script to handle Gem dependencies.
# It supports a basic vendoring system
# (just gem unpack to ./vendor)
#
# List your dependencies below and require this
# file at the very top of your program (think
# of it as a replacement for your require "rubygems").
#
# Also try:
#
#   $ ruby dependencies.rb
#
# to get a list of the required gems and to see
# which of them are vendored.

require 'rubygems'

dependencies = File.read("dependencies")

missing = []

dependencies.each_line do |line|
  next unless line =~ /^([\w\-_]+) ?([<~=> \d\.]+)?( \(([\w, ]+)\))?$/

  name, version, env = $1, $2, $4

  next if env && !env.split(/\, ?/).include?(ENV["RACK_ENV"].to_s)

  version = nil if version && version.empty?

  vendor_name = name.dup
  vendor_name << "-#{version[/([\d\.]+)$/, 1]}" if version
  vendor_path = File.join('vendor', "#{vendor_name}*", 'lib')

  if vendor_path = Dir[vendor_path].first
    # Vendored gem
    $:.unshift(File.expand_path(vendor_path))
  else
    # RubyGems
    begin
      gem(*[name, version].compact)
    rescue Gem::LoadError => e
      #$stderr.puts "=> #{e.message}"
      missing << [name, version]
    end
  end

  if $0 == __FILE__
    puts [name, version, ("(in #{vendor_path})" if vendor_path)].compact.join(" ")
  end
end

if !missing.empty?
  $stderr.puts "Missing dependencies:\n\n"

  missing.each do |spec|
    $stderr.puts "  #{spec[0]} #{spec[1]}"
  end
end

$:.unshift File.expand_path("lib")
