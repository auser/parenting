$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Parenting
  VERSION = '0.0.1' unless const_defined?(:VERSION)
end

require "parenting/base"