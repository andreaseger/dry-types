RSpec.describe Dry::Types::Hash, ':strict_with_defaults_symbolized constructor' do
  context "defaults" do
    subject(:hash) do
      Dry::Types['hash'].strict_with_defaults_symbolized(
        name: 'string',
        email: email,
        password: password,
        created_at: created_at
      )
    end

    let(:email) { Dry::Types['optional.strict.string'] }
    let(:password) { Dry::Types['strict.string'].default('changeme') }
    let(:created_at) { Dry::Types['strict.time'].default { Time.now } }

    describe '#[]' do
      it 'fills in default values' do
        result = hash[name: 'Jane', email: 'foo@bar.com']

        expect(result).to include(
                            name: 'Jane', email: 'foo@bar.com', password: 'changeme'
                          )

        expect(result[:created_at]).to be_instance_of(Time)
      end
    end
  end
  context "symbolization" do
    subject(:hash) do
      Dry::Types['hash'].strict_with_defaults_symbolized(
        name: 'string',
        email: email,
        age: 'int',
        password: password
      )
    end

    let(:email) { Dry::Types['optional.strict.string'] }
    let(:password) { Dry::Types['strict.string'].default('changeme') }

    describe '#[]' do
      it 'changes string keys to symbols' do
        expect(hash['name' => 'Jane', 'email' => 'foo@bar.com', 'age' => 1])
          .to eql(
                name: 'Jane', email: 'foo@bar.com', age: 1, password: 'changeme'
              )
      end

      it 'passes through already symbolized hash' do
        result = hash[name: 'Jane', age: 1, "email" => "foo@bar.com"]

        expect(result).to eql(name: 'Jane', age: 1, email: "foo@bar.com", password: 'changeme')
      end
    end
  end
end
