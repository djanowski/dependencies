require "dependencies/dep"

Dep.new(File.read("dependencies")).require(ENV["RACK_ENV"].to_s)
