
describe Dynasore::Cast do
  describe '.time' do
    it 'converts a Time to a UTC string in Dynamo format' do
      time = 3.hours.ago
      expect(Dynasore::Cast.time("#{time}")).to eq(Aws::Record::Marshalers::DateTimeMarshaler.new.serialize(time))
    end
  end

  describe '.integer' do
    let(:random){ SecureRandom.random_number(10_000_000_000) }

    it 'converts a string as returned from Dynamo into an int for its queries' do
      expect(Dynasore::Cast.integer("#{random}")).to eq(random)
    end
  end
end
