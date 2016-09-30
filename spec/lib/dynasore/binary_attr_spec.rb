# Encoding: UTF-8
RSpec.describe Dynasore::BinaryAttribute do
  def get_wacky
    unless Wack.table_exists?
      migration = Aws::Record::TableMigration.new(Wack)
      migration.create!(
        provisioned_throughput: {
          read_capacity_units: 1,
          write_capacity_units: 1
        }
      )
      migration.wait_until_available
    end
  end

  describe 'binary_attr :pepper' do
    class Wack
      include Aws::Record
      extend Dynasore::BinaryAttribute

      set_table_name Dynasore::Configuration.dynamo_table('wack')

      string_attr :wick, hash_key: true
      binary_attr :pepper
    end

    before(:all) { get_wacky }

    let(:wick) { 'black_powder' }

    let(:wack) { Wack.new(wick: wick) }

    it 'can save a value with UTF-8 characters' do
      wack.pepper = "I'm a lumberjack"
      expect(wack.save(force: true)).to be_truthy
    end

    it 'can save a value with non-UTF-8 characters in it' do
      wack.pepper = "\xc0 "
      expect(wack.save(force: true)).to be_truthy
    end

    it 'assigning it dirties the model' do
      wack.save(force:true)

      expect { wack.pepper = 'dionne' }.to change { wack.dirty? }.from(false).to(true)
    end

    it 'retrieves a value with non-UTF-8 characters in it' do
      wack.pepper = "\xc1 "
      wack.save(force: true)

      smack = Wack.find(wick: wick)
      expect(smack.pepper).to eq(wack.pepper)
    end

    it 'can be assigned in the #new method' do
      flack = Wack.new(wick: 'war', pepper: 'roberta')
      expect(flack.pepper).to eq('roberta')
      flack.save(force: true)

      smack = Wack.find(wick: 'war')
      expect(smack.pepper).to eq(flack.pepper)
    end
  end

  # When we get Encrypted gem'ed, we'll want this test again, somewhere (use
  # a development dependency and test it here. Until it is, if'ed it out).
  if defined?(Encrypted) && defined?(Encrypted::Accessor)
    describe 'binary_attr for both :pepper and encrypted_accessor' do
      class Wack
        include Aws::Record
        include Encrypted::Accessor
        extend Dynasore::BinaryAttribute

        set_table_name Dynasore::Configuration.dynamo_table('wack')

        string_attr :wick, hash_key: true
        encrypted_accessor :wack, declarator: :binary_attr
        binary_attr :pepper
      end

      before(:all) { get_wacky }

      let(:swack) { Wack.new(wick: 'candle') }

      it 'can be set & got' do
        swack.wack = {paddy: 'wack'}

        # Allows, but does not require that the encrypted_accessor code marshal
        # it so it reads now exactly as it will read after save & find.
        expect(swack.wack).to eq({'paddy' => 'wack'}).or eq({paddy: 'wack'})
      end

      it 'can be saved'  do
        swack.wack = {caddy: 'shack'}
        expect(swack.save(force: true)).to be_truthy
      end

      it 'can be found'  do
        swack.wack = {fanny: 'pack'}
        swack.save(force: true)

        smack = Wack.find(wick: 'candle')
        expect(smack.wack).to eq({'fanny' => 'pack'})
      end
    end
  end
end
