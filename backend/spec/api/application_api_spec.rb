describe ApplicationApi do
  context 'GET /api/greeting' do
    it 'returns a greeting' do
      get '/api/greeting'

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq('greeting' => 'Hello!')
    end
  end
end
