module Dynasore
  module BinaryAttribute
    class Marshaler
      def initialize(opts={})
      end

      # The marshaling lifecycle for these is (AFAICT):
      #
      #   setter: Neither typecast nor serialize is called; attribute is directly dirtied
      #   getter: type_cast(value) from the attributes
      #   save: serialize(type_cast(value)) is what gets saved to the DB
      #   find: just puts the value into the attributes as a string
      #
      # Our binary attributes need to be able to represent arbitrary byte
      # strings for both the pepper and the encoded values. The assumption (in
      # Crypto) is that <attr>= can take a string on the right, and that string
      # can be ASCII-8BIT encoded.  That means we can't just use aws::record
      # generated attr methods. But we can wrap them.
      def type_cast(object)
        case object
        when '' then nil
        when nil then nil
        when Dynasore::BinaryString then object
        when String then Dynasore::BinaryString.new(Base64.decode64(object))
        else
          raise ArgumentError, 'Expecting Dynasore::BinaryString'
        end
      end

      def serialize(object)
        case object
        when '' then nil
        when nil then nil
        when Dynasore::BinaryString then Base64.encode64(object)
        else
          raise ArgumentError, "Expecting Dynasore::BinaryString; can't coerce sensibly"
        end
      end
    end

    def binary_attr(name, opts={})
      binary_attr = "binary_#{name}".to_sym
      binary_opts = { dynamodb_type: 'B' }.merge(opts)

      # This is the attr defined by Aws::Record on our including class, not Module#attr
      attr(binary_attr, Marshaler.new(binary_opts), binary_opts)

      define_method name do
        send(binary_attr)
      end

      define_method "#{name}=".to_sym do |string_allowed|
        send(:"#{binary_attr}=", Dynasore::BinaryString.new(string_allowed))
      end
    end
  end
end
