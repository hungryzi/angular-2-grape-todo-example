require_dependency 'v1/representers/todo_representer'
require_dependency 'v1/representers/todos_representer'

module V1
  class TodosApi < BaseApi
    resources :todos do
      desc 'Get a single todo'
      get '/:id' do
        present Todo.find(params[:id]), with: TodoRepresenter
      end

      desc 'Get all todos'
      get '/' do
        present Todo.all, with: TodosRepresenter
      end

      desc 'Create a todo'
      params do
        requires :description, type: String, documentation: {
          param_type: 'body',
          name: 'todo'
        }
      end
      post '/' do
        todo = Todo.create!(description: params[:description])
        present todo, with: TodoRepresenter
      end
    end
  end
end
