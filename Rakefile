require 'rubygems'
require 'rake/gempackagetask'
require 'merb-core'
require 'merb-core/tasks/merb'

GEM_NAME = 'merb-ui'
AUTHOR = 'uipoet'
EMAIL = 'dont.tase@me.com'
HOMEPAGE = 'http://uipoet.com/projects'
SUMMARY = 'User Interface Components for Merb'
GEM_VERSION = '0.2.1'

spec = Gem::Specification.new do |s|
  s.rubyforge_project = AUTHOR
  s.name = GEM_NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('merb-slices', '~> 1.0.0')
  s.add_dependency('merb-helpers', '~> 1.0.0')
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{lib,app,public}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Install the gem'
task :install do
  Merb::RakeHelper.install(GEM_NAME, :version => GEM_VERSION)
end

desc 'Uninstall the gem'
task :uninstall do
  Merb::RakeHelper.uninstall(GEM_NAME, :version => GEM_VERSION)
end

desc 'Release the gem to rubyforge'
task :release do
  require 'rubyforge'
  sh 'sudo rake package'
  begin
    sh 'rubyforge login'
    sh "rubyforge add_release #{AUTHOR} #{GEM_NAME} #{GEM_VERSION} pkg/#{GEM_NAME}-#{GEM_VERSION}.gem"
  rescue Exception => e
    puts "Release failed: #{e.message}"
  end
end

desc 'Create a gemspec file'
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", 'w') do |file|
    file.puts spec.to_ruby
  end
end

require 'spec/rake/spectask'
require 'merb-core/test/tasks/spectasks'
desc 'Default: run spec examples'
task :default => 'spec'