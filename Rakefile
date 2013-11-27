ROOT_DIR = File.dirname(__FILE__)
$:.unshift ROOT_DIR

require "rake"
require "lib/doc_gen"

task :default => "generate"

desc "Generate the BalancedPayments docset"
task generate: ["generate:copy"]

namespace :generate do
  task :init do
    source_path = ENV['source']
    dest_path   = ENV['dest']

    PathHelper.set(source: source_path, dest: dest_path)
  end

  desc "Copy the raw Balanced documentation"
  task copy: :init do
    Assembler::Copier.run
  end
end