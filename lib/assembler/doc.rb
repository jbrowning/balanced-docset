require 'nokogiri'
require 'fileutils'

module Assembler
  class Doc
    def self.run(source_path, dest_path)
      new(source_path, dest_path).tap { |instance| instance.run }
    end

    attr_reader :source_path, :dest_path, :docs_to_assemble

    def initialize(source_path, dest_path)
      @source_path      = source_path
      @dest_path        = dest_path
      @docs_to_assemble = []
    end

    def run
      discover_docs
      copy_docs
    end

    def discover_docs
      source_path.each do |filename|
        docs_to_assemble << File.join(source_path, filename) if /-gen\.html/.match(filename)
      end
    end

    def copy_docs
      puts "Copying source docs to docset..."

      static_files = [
        File.join(source_path, "static/css"),
        File.join(source_path, "static/img")
      ]

      to_copy = static_files + docs_to_assemble

      clean_dest
      FileUtils.cp_r(to_copy, dest_path)
    end

    def clean_dest
      puts "Cleaning up destination directory..."
      FileUtils.rm_rf Dir.glob(File.join(dest_path, "*"))
    end
  end
end