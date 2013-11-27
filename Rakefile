ROOT_DIR = File.dirname(__FILE__)
$:.unshift ROOT_DIR

require "rake"
require "lib/doc_gen"

desc "Assemble the HTML from the raw Balanced docs"
task assemble: :init do
  Assembler::Doc.run
end

task :init do
  source_path = ENV['source']
  dest_path   = ENV['dest']

  PathHelper.set(source: source_path, dest: dest_path)
end

task :default => [:assemble]