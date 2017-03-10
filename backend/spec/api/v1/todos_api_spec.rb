describe V1::TodosApi do
  context 'GET /api/v1/todos' do
    it 'returns all todos' do
      create(:todo)
      create(:todo)

      get '/api/v1/todos'

      expect(response.status).to eq(200)

      result = JSON.parse(response.body)
      expect(result['_embedded']['todos'].length).to eq(2)
      expect(result['_links']['self']).to be_present
    end
  end

  context 'POST /api/v1/todos' do
    it 'creates a todo' do
      post '/api/v1/todos', params: { description: 'feed the cats' }

      expect(response.status).to eq(201)

      result = JSON.parse(response.body)
      expect(result['id']).to be_present
      expect(result['_links']['self']).to be_present

      todo = Todo.find result['id']
      expect(todo.description).to eq('feed the cats')
    end
  end
end
