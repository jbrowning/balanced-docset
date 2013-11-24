require 'nokogiri'
require 'fileutils'

module Assembler
  class Doc
    def self.run(source_path, dest_path)
      new(source_path, dest_path).tap { |instance| instance.run }
    end

    attr_reader :source_path, :dest_path, :html_filenames

    def initialize(source_path, dest_path)
      @source_path    = source_path
      @dest_path      = dest_path
      @html_filenames = []
    end

    def run
      discover_docs
      clean_dest
      copy_docs
      layout_docs
    end

    def discover_docs
      source_path.each do |filename|
        html_filenames << filename if /-gen\.html/.match(filename)
      end
    end

    def copy_docs
      puts "Copying source docs to docset..."

      static_files = [
        File.join(source_path, "static")
      ]
      html_files = html_filenames.map { |filename| File.join(source_path, filename) }

      to_copy = static_files + html_files

      FileUtils.cp_r(to_copy, dest_path)
    end

    def clean_dest
      puts "Cleaning up destination directory..."
      FileUtils.rm_rf Dir.glob(File.join(dest_path, "*"))
    end

    def layout_docs
      layout_path = File.join(File.dirname(__FILE__), "layout.html")
      layout_doc_file = File.open(layout_path)
      layout_doc = Nokogiri::HTML(layout_doc_file)

      files_to_layout = html_filenames.map { |filename| File.join(dest_path, filename) }

      files_to_layout.each do |filename|
        File.open(filename, "r") do |f|

          new_doc   = layout_doc.dup
          content_node = new_doc.css("#content").first
          content_node.inner_html = f.read

          File.open(filename.gsub(/\-gen/, ""), "w") do |outfile|
            new_doc.write_to(outfile)
          end
        end
      end

      layout_doc_file.close
    end
  end
end