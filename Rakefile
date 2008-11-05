require 'rubygems'
require 'rake/gempackagetask'
require "rake/rdoctask"
require "extlib"
require 'merb-core/tasks/merb_rake_helper'
require "spec/rake/spectask"

NAME = "merb-simple-forms"
GEM_VERSION = "0.0.1"
AUTHOR = "Your Name"
EMAIL = "Your Email"
HOMEPAGE = "http://merbivore.com/"
SUMMARY = "Merb plugin that provides ..."
PKG_BUILD   = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''

spec = Gem::Specification.new do |s|
  s.rubyforge_project = 'merb-simple-forms'
  s.name = NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.files = %w(LICENSE README Rakefile Generators TODO) + Dir.glob("{lib,spec,public/Library/Ruby/Gems/1.8/gems/templater-0.3.3/}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem"
task :install do
  Merb::RakeHelper.install(NAME, :version => GEM_VERSION)
end

desc "Uninstall the gem"
task :uninstall do
  Merb::RakeHelper.uninstall(NAME, :version => GEM_VERSION)
end

desc "Create a gemspec file"
task :gemspec do
  File.open("#{GEM_NAME}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Run all examples (or a specific spec with TASK=xxxx)"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts  = ["-cfs"]
  t.spec_files = begin
    if ENV["TASK"] 
      ENV["TASK"].split(',').map { |task| "spec/**/#{task}_spec.rb" }
    else
      FileList['spec/**/*_spec.rb']
    end
  end
end

desc 'Default: run spec examples'
task :default => 'spec'