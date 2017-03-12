describe V1::TodosApi do
  describe 'GET /api/v1/todos/:id' do
    context 'when exists' do
      it 'returns correct todo' do
        todo = create(:todo)

        get "/api/v1/todos/#{todo.id}", params: {}, headers: request_headers

        expect(response.status).to eq(200)

        expect(json_response[:description]).to eq(todo.description)
        expect(json_response[:complete]).to eq(todo.complete)
        expect(json_response[:_links][:self][:href]).to end_with("/api/v1/todos/#{todo.id}")
      end
    end

    context 'when not exists' do
      it 'returns nice error' do
        get '/api/v1/todos/42', params: {}, headers: request_headers

        expect(response.status).to eq(404)

        expect(json_response[:errors]).to eq(
          [
            message: "Couldn't find Todo with 'id'=42",
            model: 'Todo',
            attribute: 'id',
            value: '42'
          ]
        )
        expect(json_response[:status_code]).to eq(404)
      end
    end
  end

  describe 'GET /api/v1/todos' do
    it 'returns all todos' do
      create_list(:todo, 3)

      allow(Todo).to receive(:default_per_page).and_return(1)

      get '/api/v1/todos', params: nil,
                           headers: request_headers

      expect(response.status).to eq(200)

      expect(json_response[:_embedded][:todos].length).to eq(1)
      expect(json_response[:total_pages]).to eq(3)
      expect(json_response[:count]).to eq(1)
    end

    describe 'links' do
      before do
        create_list(:todo, 10)
        allow(Todo).to receive(:default_per_page).and_return(4)
      end

      specify do
        get '/api/v1/todos', params: {},
                             headers: request_headers, as: :json

        expect(json_response[:_links][:self][:href]).to end_with('/api/v1/todos')
        expect(json_response[:_links][:first]).not_to be_present
        expect(json_response[:_links][:prev]).not_to be_present
        expect(json_response[:_links][:next][:href]).to end_with('/api/v1/todos?page=2')
        expect(json_response[:_links][:last][:href]).to end_with('/api/v1/todos?page=3')
      end

      specify do
        get '/api/v1/todos', params: { page: 2 },
                             headers: request_headers

        expect(json_response[:_links][:self][:href]).to end_with('/api/v1/todos?page=2')
        expect(json_response[:_links][:first][:href]).to end_with('/api/v1/todos?page=1')
        expect(json_response[:_links][:prev][:href]).to end_with('/api/v1/todos?page=1')
        expect(json_response[:_links][:next][:href]).to end_with('/api/v1/todos?page=3')
        expect(json_response[:_links][:last][:href]).to end_with('/api/v1/todos?page=3')
      end

      specify do
        get '/api/v1/todos', params: { page: 3, per_page: 4 },
                             headers: request_headers

        expect(json_response[:_links][:self][:href]).to end_with('/api/v1/todos?page=3&per_page=4')
        expect(json_response[:_links][:first][:href]).to end_with('/api/v1/todos?page=1&per_page=4')
        expect(json_response[:_links][:prev][:href]).to end_with('/api/v1/todos?page=2&per_page=4')
        expect(json_response[:_links][:next]).not_to be_present
        expect(json_response[:_links][:last]).not_to be_present
      end
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
