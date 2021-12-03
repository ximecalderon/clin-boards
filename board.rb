require "json"
require_relative "./list.rb"

class Board
    attr_reader :lists
    def initialize(id:, name:, description:, lists:)
        @id = id
        @name = name
        @description = description
        @lists = lists.map {|list| List.new(list)}

    end

    def data
      pp  todo = @lists.select{|list| list.name == "Todo"}.length
      pp  in_progress = @lists.select{|list| list.name == "In progress"}.length
      pp  code_review = @lists.select{|list| list.name == "Code Review"}.length
      pp  done = @lists.select{|list| list.name == "Done"}.length
        
     [@id, @name, @description, "Todo(#{todo}), In progress(#{in_progress}), Code Review(#{code_review}), Done(#{done})" ]
    end

end

# boar = Board.new
# pp boar.data