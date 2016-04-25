require 'spec_helper'
# TODO: These should just be swapped to handle the same level of coverage for message_events module




RSpec.describe SparkPost::Transmission do
  describe '#initialize' do
    context 'when api key and host are passed'
    let(:message_events) do
      SparkPost::Message_events.new('123', 'http://sparkpost.com')
    end

    it { expect(transmission.instance_variables).to include(:@api_key) }
    it { expect(transmission.instance_variables).to include(:@api_host) }
    it { expect(transmission.class_variables).to include(:@@valid_query_params) }
    it { expect(transmission.instance_variable_get(:@api_key)).to eq('123') }

    it do
      expect(transmission.instance_variable_get(:@api_host))
        .to eq('http://sparkpost.com')
    end

    it do
      expect(transmission.instance_variable_get(:@base_endpoint))
        .to eq('https://sparkpost.com/api/v1/message-events')
    end

    context 'when api key or host not passed' do
      it 'raises when api key and host not passed' do
        expect { SparkPost::Transmission.new }
          .to raise_error(ArgumentError)
      end
      it 'raises when host not passed' do
        expect { SparkPost::Transmission.new(123) }
          .to raise_error(ArgumentError)
      end
    end
  end

  describe '#endpoint' do
    let(:message_events) do
      SparkPost::Message_events.new('123456','https://api.sparkpost.com')
    end
    let(:url) { 'https://sparkpost.com/api/v1/message-events' }

    it 'returns correct endpoint' do
      expect(message_events.endpoint).to eq(url)
    end

    it 'returns correct endpoint on subsequent calls' do
      transmission.endpoint
      expect(message_events.endpoint).to eq(url)
    end
  end
  
  









  # describe '#send_payload' do
  #   let(:transmission) do
  #     SparkPost::Transmission.new('123456', 'https://api.sparkpost.com')
  #   end
  #   let(:url) { 'https://api.sparkpost.com/api/v1/transmissions' }
  #   let(:data) do
  #     {
  #       recipients: [
  #         {
  #           address: {
  #             email: 'to@me.com', name: 'Me', header_to: 'no@reply.com'
  #           }
  #         }
  #       ],
  #       content: {
  #         from: { email: 'me@me.com', name: 'Me' },
  #         subject: 'test subject',
  #         text: 'Hello Sparky',
  #         html: '<h1>Hello Sparky</h1>'
  #       }
  #     }
  #   end

  #   it 'calls request with correct data' do
  #     allow(transmission).to receive(:request) do |req_url, req_api_key, req_data|
  #       expect(req_api_key).to eq('123456')
  #       expect(req_url).to eq(url)
  #       expect(req_data).to eq(data)
  #     end

  #     transmission.send_payload(data)
  #   end

  #   it 'passes through delivery exception' do
  #     allow(transmission).to receive(:request).and_raise(
  #       SparkPost::DeliveryException.new('Some delivery error'))

  #     bad_data = data.merge(recipients: [])

  #     expect do
  #       transmission.send_payload(bad_data)
  #     end.to raise_error(SparkPost::DeliveryException).with_message(
  #       /Some delivery error/)
  #   end

  #   it 'passes responses' do
  #     allow(transmission).to receive(:request).and_return(success: 1)
  #     expect(transmission.send_payload(data)).to eq(success: 1)
  #   end
  # end

  # describe '#send_message' do
  #   let(:transmission) do
  #     SparkPost::Transmission.new('123456', 'https://api.sparkpost.com')
  #   end
  #   let(:url) { 'https://api.sparkpost.com/api/v1/transmissions' }
  #   before do
  #     allow(transmission).to receive(:request).and_return({})
  #   end

  #   it 'calls send_payload with prepared data' do
  #     prepared_data = {
  #       recipients: [
  #         {
  #           address: {
  #             email: 'to@me.com'
  #           }
  #         }
  #       ],
  #       content: {
  #         from: 'me@me.com',
  #         subject: 'test subject',
  #         text: 'hello sparky',
  #         html: '<h1>Hello Sparky</h1>'
  #       },
  #       options: {}
  #     }

  #     expect(transmission).to receive(:send_payload).with(prepared_data)
  #     transmission.send_message(
  #       'to@me.com',
  #       'me@me.com',
  #       'test subject',
  #       '<h1>Hello Sparky</h1>',
  #       text_message: 'hello sparky'
  #     )
  #   end

  #   it 'requests correct endpoint' do
  #     allow(transmission).to receive(:request) do |request_url|
  #       expect(request_url).to eq(url)
  #     end

  #     transmission.send_message(
  #       'to@example.com',
  #       'from@example.com',
  #       'test subject',
  #       '<h1>Hello World</h1>')
  #   end

  #   it 'calls prepare_attachments' do
  #     allow(transmission).to receive(:request)

  #     allow(transmission).to receive(:prepare_recipients) do |recipients|
  #       expect(recipients).to eq('to@example.com')
  #     end

  #     transmission.send_message(
  #       'to@example.com',
  #       'from@example.com',
  #       'test subject',
  #       '<h1>Hello World</h1>')
  #   end

  #   it 'requests with correct parameters' do
  #     allow(transmission).to receive(:request) do |_url, _api_key, data|
  #       expect(data[:recipients].length).to eq(1)
  #       expect(data[:recipients][0][:address]).to eq(email: 'to@example.com')
  #       expect(data[:content][:from]).to eq('from@example.com')
  #       expect(data[:content][:subject]).to eq('test subject')
  #       expect(data[:content][:html]).to eq('<h1>Hello World</h1>')
  #     end
  #     transmission.send_message(
  #       'to@example.com',
  #       'from@example.com',
  #       'test subject',
  #       '<h1>Hello World</h1>')
  #   end

  #   it 'raises erorr when no content passed' do
  #     expect do
  #       transmission.send_message(
  #         ['to@example.com'],
  #         'from@example.com',
  #         'test subject')
  #     end.to raise_error(ArgumentError).with_message(/Content missing/)
  #   end

  #   it 'it does not raise error when text_message passed' do
  #     expect do
  #       transmission.send_message(
  #         ['to@example.com'],
  #         'from@example.com',
  #         'test subject',
  #         nil,
  #         text_message: 'hello world')
  #     end.to_not raise_error
  #   end

  #   it 'passes through delivery exception' do
  #     allow(transmission).to receive(:request).and_raise(
  #       SparkPost::DeliveryException.new('Some delivery error'))

  #     expect do
  #       transmission.send_message(
  #         'to@example.com',
  #         'from@example.com',
  #         'test subject',
  #         '<h1>Hello World</h1>')
  #     end.to raise_error(SparkPost::DeliveryException).with_message(
  #       /Some delivery error/)
  #   end

  #   it 'passes responses' do
  #     allow(transmission).to receive(:request).and_return(success: 1)
  #     expect(transmission.send_message(
  #       'to@example.com',
  #       'from@example.com',
  #       'test subject',
  #       '<h1>Hello World</h1>')).to eq(success: 1)
  #   end

  #   it 'sends attachments' do
  #     attachment = {
  #       name: 'attachment.txt',
  #       type: 'text/plain',
  #       data: Base64.encode64('Hello World')
  #     }
  #     options = {
  #       attachments: [attachment]
  #     }

  #     allow(transmission).to receive(:request) do |_url, _api_key, data|
  #       expect(data[:content][:attachments]).to be_kind_of(Array)
  #       expect(data[:content][:attachments].length).to eq(1)
  #       expect(data[:content][:attachments][0]).to eq(attachment)
  #     end
  #     transmission.send_message(
  #       ['to@example.com'],
  #       'from@example.com',
  #       'test subject',
  #       '<h1>Hello World</h1>',
  #       options)
  #   end
  # end

  # describe '#prepare_recipients' do
  #   let(:transmission) do
  #     SparkPost::Transmission.new('123456', 'https://api.sparkpost.com')
  #   end

  #   it 'returns an array' do
  #     expect(transmission.prepare_recipients('to@domain.com')).to be_kind_of(Array)
  #   end

  #   it 'handles a recipient hash with email, name and header_to correctly' do
  #     prepared_recipients = transmission.prepare_recipients(
  #       email: 'to@me.com', name: 'Me', header_to: 'no@reply.com'
  #     )

  #     expect(prepared_recipients.length).to eq(1)
  #     expect(prepared_recipients[0]).to eq(address: { email: 'to@me.com', name: 'Me', header_to: 'no@reply.com' })
  #   end

  #   it 'handles array of recipient hashes correctly' do
  #     prepared_recipients = transmission.prepare_recipients(
  #       [{ email: 'to@me.com', name: 'Me', header_to: 'no@reply.com' }]
  #     )
  #     expect(prepared_recipients.length).to eq(1)
  #     expect(prepared_recipients[0]).to eq(address: { email: 'to@me.com', name: 'Me', header_to: 'no@reply.com' })
  #   end

  #   it 'handles array of recipients correctly' do
  #     expect(
  #       transmission.prepare_recipients(['to@example.com'])
  #     ).to eq([{ address: { email: 'to@example.com' } }])
  #   end

  #   it 'raises for invalid recipient hash' do
  #     expect do
  #       transmission.prepare_recipients(name: 'Me', header_to: 'no@reply.com')
  #     end.to raise_error(ArgumentError, /email missing/)
  #   end

  #   it 'throws for an array of invalid recipient hashes' do
  #     expect do
  #       transmission.prepare_recipients(
  #         [
  #           { to: 'to@me.com', name: 'Me', header_to: 'no@reply.com' },
  #           { name: 'You', header_to: 'no@reply.com' }
  #         ]
  #       )
  #     end.to raise_error(ArgumentError, /email missing/)
  #   end
  # end
end
