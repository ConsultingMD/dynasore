module Dynasore
  module Cast
    def self.time(ruby_time)
      Aws::Record::Marshalers::DateTimeMarshaler.new.serialize(ruby_time)
    end

    def self.integer(string_or_int)
      Integer(string_or_int)
    end
  end
end
