module PathHelper
  extend self

  DEFAULT_SOURCE_PATH = File.expand_path("../balanced-docs/", ROOT_DIR)
  DEFAULT_DEST_PATH = File.expand_path("build/BalancedPayments.docset", ROOT_DIR)

  attr_reader :source, :dest

  def set(options={})
    set_source options[:source]
    set_dest options[:dest]
  end

  def set_source(source_path)
    @source = OpenStruct.new
    @source.top = source_path || DEFAULT_SOURCE_PATH
    @source.site = File.join(@source.top, "site")
    @source.static = File.join(@source.site, "static")
  end

  def set_dest(dest_path)
    @dest = OpenStruct.new
    @dest.top = dest_path || DEFAULT_DEST_PATH
    @dest.contents  = File.join(@dest.top, "Contents")
    @dest.resources = File.join(@dest.contents, "Resources")
    @dest.documents = File.join(@dest.resources, "Documents")
  end
end
PathHelper.set