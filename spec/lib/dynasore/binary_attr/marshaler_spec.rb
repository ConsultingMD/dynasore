
RSpec.describe Dynasore::BinaryAttribute::Marshaler do

  let(:marshaler) { Dynasore::BinaryAttribute::Marshaler.new }

  describe '#type_cast' do
    it 'maps nil to nil' do
      expect(marshaler.type_cast(nil)).to be_nil
    end
    it 'maps the empty string to nil' do
      expect(marshaler.type_cast('')).to be_nil
    end
    it 'leaves BinaryString alone' do
      foo = Dynasore::BinaryString.new("bar")
      expect(marshaler.type_cast(foo)).to eq(foo)
    end

    it 'base64 decodes Strings' do
      plain_text = "bar"
      b64 = Base64::encode64(plain_text)
      expect(marshaler.type_cast(b64)).to eq(plain_text)
    end

    it 'raises like other Aws::Record marshalers' do
      expect{marshaler.type_cast(%w(an array))}.to raise_error(ArgumentError)
    end
  end

  describe '#serialize' do
    it 'maps nil to nil' do
      expect(marshaler.serialize(nil)).to be_nil
    end

    it 'maps the empty string to nil' do
      expect(marshaler.serialize('')).to be_nil
    end

    it 'encodes BinaryString' do
      foo = Dynasore::BinaryString.new("bar")
      expect(marshaler.serialize(foo)).to eq(Base64.encode64(foo))
    end

    it 'raises like other Aws::Record marshalers when it sees the unexpected' do
      expect{marshaler.serialize(String)}.to raise_error(ArgumentError)
    end
  end
end
