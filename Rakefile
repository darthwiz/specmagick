require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# from https://gist.github.com/DevL/4285948

namespace :generate do
  desc 'Generate a timestamped, empty Sequel migration.'
  task :migration, :name do |_, args|
    if args[:name].nil?
      puts 'You must specify a migration name (e.g. rake generate:migration[create_events])!'
      exit false
    end
    content   = "Sequel.migration do\n\n  up do\n  end\n\n  down do\n  end\n\nend\n"
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    filename  = File.join(File.dirname(__FILE__), 'lib/specmagick/db/migrations', "#{timestamp}_#{args[:name]}.rb")
    File.open(filename, 'w') { |f| f.puts content }
    puts "Created the migration #{filename}"
  end
end
