describe V1::TodosApi do
  context 'GET /api/v1/todos' do
    it 'returns all todos' do
      create(:todo)
      create(:todo)

      get '/api/v1/todos', params: nil,
                           headers: request_headers

      expect(response.status).to eq(200)

      expect(json_response['_embedded']['todos'].length).to eq(2)
      expect(json_response['_links']['self']).to be_present
    end
  end

  context 'POST /api/v1/todos' do
    it 'creates a todo' do
      post '/api/v1/todos', params: { description: 'feed the cats' }.to_json,
                            headers: request_headers

      expect(response.status).to eq(201)

      expect(json_response['id']).to be_present
      expect(json_response['_links']['self']).to be_present

      todo = Todo.find json_response['id']
      expect(todo.description).to eq('feed the cats')
    end
  end
end
