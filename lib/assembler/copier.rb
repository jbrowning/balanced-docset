module Assembler
  class Copier
    include Helpers

    def perform
      clean_dest
      copy_docs
    end

    def clean_dest
      puts "Cleaning up destination directory..."
      FileUtils.rm_rf Dir.glob(File.join(PathHelper.dest.documents, "*"))
    end

    def copy_docs
      puts "Copying source docs to docset..."

      static_files = [
        File.join(PathHelper.source.static)
      ]
      html_files = html_filenames.map { |filename| File.join(PathHelper.source.site, filename) }

      to_copy = static_files + html_files

      FileUtils.cp_r(to_copy, PathHelper.dest.documents)
    end
  end
end