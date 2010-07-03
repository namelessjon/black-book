#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
require 'hashidator'

# A hash with defined keys
#
# This is somewhat similar to the 'Dash' provided by Hashie, but it has
# hashidator validations baked in, and in addition, supports the idea of
# optional columns.  It also allows for sensible merging of such values.
class DefinedHash < Hash

  def initialize(attributes={})
    self.class.add_properties(self.class.properties, self, attributes)
  end


  def self.property(name, type, opts={})
    validator = opts.fetch(:optional, false) ? proc { |v| v.nil? ? true : type } : type
    (@properties ||= {})[name]  = type
    (@validations ||= {})[name] = validator
  end

  def self.properties
    (@properties || {})
  end

  def self.validations
    (@validations || {})
  end

  def self.add_properties(properties, hash, attributes)
    properties.each do |name, type|
      add_property(hash, attributes, name, type)
    end
  end

  def self.add_property(hash, attributes, name, type)
    case type
    when Array
      value = attributes[name] if attributes.has_key?(name)
      value = attributes[name.to_s] if attributes.has_key?(name.to_s)
      if value
        value = (Array === value) ? value : [value]
        case type.first
        when Hash
          array = []
          value.each do |v|
            tmp = {}
            add_properties(type.first, tmp, v)
            array << tmp unless tmp.empty?
          end
          hash[name] = array unless array.empty?
        else
          hash[name] = value
        end
      end
    else
      hash[name] = attributes[name] if attributes.has_key?(name)
      hash[name] = attributes[name.to_s] if attributes.has_key?(name.to_s)
    end
  end


  def valid?
    Hashidator.validate(self.class.validations, self)
  end

  def merge!(hash)
    self.class.add_properties(self.class.properties, self, hash)
  end

  def to_hash
    out = {}
    keys.each do |k|
      out[k] = self[k]
    end
    out
  end
end
