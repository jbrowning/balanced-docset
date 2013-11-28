module Assembler
  class Pruner
    include Helpers

    attr_reader :docs

    def perform
      load_docs
      layout_docs
      prune_docs
      write_docs
      # rename_docs
    end

    def target_file_paths
      return @target_file_paths if defined? @target_file_paths
      @target_file_paths = html_filenames.map { |filename|
        File.join(PathHelper.dest.documents, filename)
      }
    end

    def load_docs
      puts "Loading docs..."
      @docs = []
      target_file_paths.each do |path|
        File.open(path, "r") do |f|
          puts "Loading #{f.path}"
          @docs << Nokogiri::HTML(f)
        end
      end
    end

    def layout
      return @layout if defined? @layout
      layout_path = File.join(File.dirname(__FILE__), "layout.html")
      File.open(layout_path, "r") do |f|
        @layout = Nokogiri::HTML(f)
      end
      @layout
    end

    def layout_docs
      puts "Wrapping docs in layout..."

      docs.each do |doc|
        existing_content = doc.inner_html
        doc.inner_html = layout.inner_html
        content_node = doc.css("#content").first
        content_node.inner_html = existing_content
        puts doc.url
      end
    end

    def write_docs
      puts "Saving docs..."
      docs.each do |doc|
        File.open(doc.url, "w") do |f|
          doc.write_html_to f
        end
      end
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

    def prune_docs(retain_language=:ruby)
      docs.each do |doc|
        delete_menu(doc)
        delete_permalink_contents(doc)
        delete_unnecessary_examples(doc, retain_language)
      end
    end

    def delete_menu(doc)
      menu_node = doc.css(".context-sidebar").first
      menu_node.remove
    end

    def delete_permalink_contents(doc)
      doc.css(".headerlink").each { |node| node.content = "" }
    end

    def delete_unnecessary_examples(doc, retain_language=:ruby)
      delete_languages = [:ruby, :bash, :java, :php, :python] - [retain_language]

      delete_languages.each do |language|
        example_code_nodes = doc.css(".highlight-#{language}")
        example_code_nodes.each(&:remove)
      end
    end
  end
end