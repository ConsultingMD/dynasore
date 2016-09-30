
RSpec.describe Dynasore::Configuration do
  let(:configuration) { Dynasore::Configuration.new }

  describe 'Dynasore.configure' do
    it 'yields the Singleton instance' do
      expect {|b| Dynasore.configure(&b) }.to yield_with_args( Dynasore::Configuration.instance )
    end
  end

  # I suppose we should extract this configuration pattern into its
  # own gem or gist so 'configurable_attr' can its own test, but this
  # gets adequate initial coverage
  describe 'configurable_attr' do
    it 'table_name_prefix= sets the prefix' do
      expect(configuration.table_name_prefix = 'foobar').to eq('foobar')
    end

    it 'table_name_prefix returns the prefix later' do
      configuration.table_name_prefix = 'foobar'
      expect(configuration.table_name_prefix).to eq('foobar')
    end

    it 'table_name_prefix configures the instance if not already done' do
      expect {configuration.table_name_prefix}.to change { configuration.instance_variable_get(:@configured) }.from(nil).to(true)
    end

    it 'table_name_prefix is available at the class level' do
      expect(Dynasore::Configuration).to respond_to(:table_name_prefix)
    end

    it 'the class method calls the method on the global instance' do
      expect(Dynasore::Configuration).to receive(:table_name_prefix).and_call_original
      Dynasore::Configuration.table_name_prefix
    end
  end

  describe '#dynamo_table' do
    subject(:dynamo_table) { configuration.dynamo_table('wackamole') }

    context 'when no table prefix has been specified' do
      before do
        # Make sure we don't read the test: configuration
        configuration.config_file = "/this/file/does/not/exist.yml"
      end

      specify{ expect(dynamo_table).to eq('wackamole') }
    end

    context 'when a prefix is configured' do
      before do
        configuration.table_name_prefix = "g"
      end

      specify{ expect(dynamo_table).to eq('g.wackamole') }
    end
  end
end
