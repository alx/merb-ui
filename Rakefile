require 'rubygems'
require 'rake'

spec = Gem::Specification.new do |s|
  s.add_dependency('merb-helpers', '~> 1.0.0')
  s.add_dependency('merb-slices', '~> 1.0.0')
  s.files = FileList['app/**/*', 'lib/**/*', 'public/**/*', '[A-Z]*'].to_a
  s.name = 'merb-ui'
  s.rubyforge_project = 'uipoet'
  s.summary = 'User Interface Components for Merb'
  s.version = '0.3'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Create gemspec'
task :gemspec do
  File.open("#{spec.name}.gemspec", 'w') do |file|
    file.puts spec.to_ruby
  end
end

desc 'Install gem'
task :install do
  Merb::RakeHelper.install(spec.name, :version => spec.version)
end

desc 'Release gem to rubyforge.org'
task :release do
  require 'rubyforge'
  sh 'sudo rake package'
  begin
    sh 'rubyforge login'
    sh "rubyforge add_release #{spec.rubyforge_project} #{spec.name} #{spec.version} pkg/#{spec.name}-#{spec.version}.gem"
  rescue Exception => e
    puts "Release failed: #{e.message}"
  end
end

desc 'Uninstall gem'
task :uninstall do
  Merb::RakeHelper.uninstall(spec.name, :version => spec.name)
end
