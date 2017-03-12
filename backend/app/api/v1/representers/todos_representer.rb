require_relative './collection_representer'

module V1
  module TodosRepresenter
    include CollectionRepresenter

    collection :entries, extend: TodoRepresenter, as: :todos, embedded: true
  end
end
