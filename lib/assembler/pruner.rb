module Assembler
  class Pruner
    include Helpers

    def perform
      layout_docs
      sweep_old_docs
    end

    def layout_docs
      puts "Wrapping docs in layout..."
      layout_path = File.join(File.dirname(__FILE__), "layout.html")
      layout_doc_file = File.open(layout_path, "r")
      layout_doc = Nokogiri::HTML(layout_doc_file)

      files_to_layout = html_filenames.map { |filename|
        File.join(PathHelper.dest.documents, filename)
      }

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

    def sweep_old_docs
      puts "Deleting old docs..."
      files_to_delete = html_filenames.map { |filename|
        File.join(PathHelper.dest.documents, filename)
      }

      files_to_delete.each do |filename|
        FileUtils.rm filename
      end
    end
  end
end