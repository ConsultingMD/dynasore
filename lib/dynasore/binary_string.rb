module Dynasore
  class BinaryString < String
    def initialize(str)
      str.force_encoding('ASCII-8BIT')
      super str
    end
  end
end
