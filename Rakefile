require "rake"
require "./lib/doc_gen"

desc "Assemble the HTML from the raw Balanced docs"
task :assemble do
  source_path = Dir.new(File.expand_path(DocGen::DEFAULT_SOURCE_PATH))
  dest_path   = Dir.new(File.expand_path(DocGen::DEFAULT_DEST_DOCUMENTS_PATH))

  Assembler::Doc.run source_path, dest_path
end

task :default => [:assemble]