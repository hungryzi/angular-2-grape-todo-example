require_relative './representers/todo_representer'
require_relative './representers/todos_representer'

module V1
  class TodosApi < Grape::API
    get 'todos/:id' do
      present Todo.find(params[:id]), with: TodoRepresenter
    end

    get 'todos' do
      present Todo.all, with: TodosRepresenter
    end

    post 'todos' do
      todo = Todo.create!(description: params[:description])
      present todo, with: TodoRepresenter
    end
  end
end
