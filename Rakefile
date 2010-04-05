task :test do
  binary = File.open($0) { |f| f.gets }[/#\s*!\s*(.*)/, 1]
  puts "Running suite with #{binary}"
  system "cd test && env GEM_HOME=#{File.expand_path("tmp")} #{binary} dependencies_test.rb"
end

task :default => :test
