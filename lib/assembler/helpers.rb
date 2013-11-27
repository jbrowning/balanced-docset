module Helpers
  def self.included(base)
    base.extend ClassMethods
  end

  def html_filenames
    return @html_filenames if defined? @html_filenames
    @html_filenames = []
    Dir.new(PathHelper.source.site).each do |filename|
      @html_filenames << filename if /-gen\.html/.match(filename)
    end
    @html_filenames
  end

  module ClassMethods
    def perform
      new.tap { |instance| instance.perform }
    end
  end
end