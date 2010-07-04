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
    attributes.each do |name, value|
      self[name] = value
    end
  end


  def []=(name, value)
    if (property_name = self.class.property_names.detect { |pn| pn == name.to_s })
      property_name = property_name.to_sym # we know it's a defined name, so this isn't a leak.
      property      = self.class.properties[property_name]
      case property
      when Array
        value = self.class.typecast_value_to_array(property, value)
        if has_key?(property_name)
          self[property_name].concat( value )
        else
          super(property_name, value)
        end
      when Class
        super(property_name, self.class.typecast_value_to_class(property, value))
      else
        super(property_name, value)
      end
    end
    # ignore properties without names
  end

  def self.typecast_value_to_class(klass, value)
    if klass < DefinedHash # if we have a defined hash, make it new!
      value = klass.new(value) unless klass === value
    end
    value
  end



  def self.typecast_value_to_array(property, value)
    value = (Array === value) ? value : [value]
    case property.first
    when Hash
      return value.map { |v| self.typecast_value_to_hash(property.first, v) }
    when Class
      return value.map { |v| self.typecast_value_to_class(property.first, v) }
    end
    value
  end

  def self.typecast_value_to_hash(property, values)
    hash = {}
    keys = property.keys.map { |k| k.to_s }
    values.each do |name, value|
      name = name.to_s
      if keys.include?(name)
        hash[name.to_sym] = value
      end
    end
    hash
  end

  def self.property(name, type, opts={})
    # use a DefinedHash's inbuilt validations if we have a defined hash
    klass_validator = class_validator_for(type)
    klass_validator = (Array === klass_validator and
                       Class === klass_validator.first and
                       klass_validator.first < DefinedHash) ? [class_validator_for(klass_validator.first)] : klass_validator

    # optional validations done via proc
    validator = opts.fetch(:optional, false) ? proc { |v| v.nil? ? true : klass_validator } : klass_validator

    (@properties ||= {})[name]  = type
    (@validations ||= {})[name] = validator
  end

  def self.class_validator_for(type)
    (Class === type and type < DefinedHash) ? proc { |v| v.valid? } : type
  end

  def self.property_names
    properties.keys.map { |p| p.to_s }
  end

  def self.properties
    (@properties || {})
  end

  def self.validations
    (@validations || {})
  end

  def valid?
    Hashidator.validate(self.class.validations, self)
  end

  def merge!(hash)
    hash.each do |key, value|
      self[key] = value
    end
  end

  def to_hash
    out = {}
    keys.each do |k|
      out[k] = self[k]
    end
    out
  end
end
