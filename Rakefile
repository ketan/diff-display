# encoding: utf-8

require 'rubygems'
require 'rake/testtask'

require './lib/diff-display.rb'

task "gemspec" do
  spec = Gem::Specification.new do |s|
    s.name            = "diff-display"
    s.version         = Diff::Display::VERSION::STRING
    s.platform        = Gem::Platform::RUBY
    s.summary         = "Diff::Display::Unified renders unified diffs into various forms."
    
    s.description     = %Q{Diff::Display::Unified renders unified diffs into various forms. The output is based on a callback object that's passed into the renderer}

    s.files           = `git ls-files`.split("\n") + %w(diff-display.gemspec)
    s.require_path    = 'lib'
    s.has_rdoc        = false
    s.extra_rdoc_files = ['README.txt']
    s.test_files      = Dir['test/{test,spec}_*.rb']
    
    s.authors          = ['Johan Sørensen', 'Ketan Padegaonkar']
    s.email           = ['johan@johansorensen.com', 'KetanPadegaonkar@gmail.com']
    s.homepage        = 'http://github.com/ketan/diff-display'
    
    s.add_development_dependency 'mocha'
  end

  File.open("diff-display.gemspec", "w") { |f| f << spec.to_ruby }
end

task :gem => ["gemspec"] do
  rm_rf 'pkg'
  sh "gem build diff-display.gemspec"
  mkdir 'pkg'
  mv "diff-display-#{Diff::Display::VERSION::STRING}.gem", "pkg"
end

task :test do
  Rake::TestTask.new do |t|
     t.libs << "test"
     t.test_files = FileList['test/test_*.rb']
     t.verbose = true
   end
end

task :default => :test