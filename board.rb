require "json"
require_relative "./list.rb"

class Board
    attr_reader :id, :name, :lists

    @@id_count = 0
    def initialize(name:, description:, id: nil, lists: [])
        @id = id || @@id_count.next
        @name = name
        @description = description
        @lists = [] #[List1, List2]

    end

    def details
        [@id, @name, @description, "List"]
    end
    
    # def data
    #   todo = @lists.select{|list| list.name == "Todo"}.length
    #   in_progress = @lists.select{|list| list.name == "In progress"}.length
    #   code_review = @lists.select{|list| list.name == "Code Review"}.length
    #   done = @lists.select{|list| list.name == "Done"}.length
        
    #  @holi = [@id, @name, @description, "Todo(#{todo}), In progress(#{in_progress}), Code Review(#{code_review}), Done(#{done})" ]
    # end



end

# boar = Board.new
# pp boar.data