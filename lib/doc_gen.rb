$:.unshift File.dirname(__FILE__)

require 'bundler/setup'
require 'assembler/doc'

class DocGen
  THIS_DIR = File.dirname(__FILE__)
  DEFAULT_DOCS_PATH = File.expand_path("../../balanced-docs/", THIS_DIR)
  DEFAULT_SOURCE_PATH = File.join(DEFAULT_DOCS_PATH, "site")
  DEFAULT_DEST_PATH = File.expand_path("../build/BalancedPayments.docset/Contents/", THIS_DIR)
  DEFAULT_DEST_DOCUMENTS_PATH = File.join(DEFAULT_DEST_PATH, "Resources/Documents")
end