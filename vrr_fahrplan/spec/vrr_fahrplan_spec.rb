require 'vrr_fahrplan'
require 'json'

describe VrrFahrplan::LiveQuery do
    subject { VrrFahrplan::LiveQuery.new }

    describe '#send_vrr_request' do
        let(:output) { subject.send_vrr_request('bochum', 'hbf', 'bochum', 'uni', '16:37') }

        it 'returns not nil' do
            expect(output).should_not be_nil
        end
    end


    describe '#parse' do
        let(:input) { subject.send_vrr_request('bochum', 'hbf', 'bochum', 'uni', '16:37') } 
        let(:output) { subject.parse(input) }

        it 'has trips' do
            expect(output.length).to be > 0
        end

        it 'has as name Bochum Hbf' do
            expect(output[0][:name]).to match /Bochum Hbf/
        end 
    end
end
