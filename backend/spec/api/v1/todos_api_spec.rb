describe V1::TodosApi do
  describe 'GET /api/v1/todos' do
    it 'returns all todos' do
      create(:todo)
      create(:todo)

      get '/api/v1/todos', params: nil,
                           headers: request_headers

      expect(response.status).to eq(200)

      expect(json_response[:_embedded][:todos].length).to eq(2)
      expect(json_response[:_links][:self]).to be_present
    end
  end

  describe 'POST /api/v1/todos' do
    context 'when valid' do
      subject(:make_request) do
        post '/api/v1/todos', params: { description: 'feed the cats' }.to_json,
                              headers: request_headers
      end

      it 'creates a todo' do
        expect { make_request }.to change(Todo, :count).by(1)
        expect(response.status).to eq(201)

        expect(json_response[:id]).to be_present
        expect(json_response[:_links][:self]).to be_present

        todo = Todo.find json_response[:id]
        expect(todo.description).to eq('feed the cats')
      end
    end

    context 'when invalid params' do
      subject(:make_request) { post '/api/v1/todos', params: {}, headers: request_headers }

      it 'returns error' do
        expect { make_request }.not_to change(Todo, :count)
        expect(response.status).to eq(422)
        expect(json_response[:errors]).to eq([message: 'is missing', attribute: 'description'])
        expect(json_response[:status_code]).to eq(422)
      end
    end

    context 'when record is invalid' do
      subject(:make_request) { post '/api/v1/todos', params: { description: '' }.to_json, headers: request_headers }

      it 'returns error' do
        expect { make_request }.not_to change(Todo, :count)
        expect(response.status).to eq(422)
        expect(json_response[:errors]).to eq([message: "can't be blank", attribute: 'description'])
        expect(json_response[:status_code]).to eq(422)
      end
    end
  end
end
