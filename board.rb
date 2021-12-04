require "json"
require_relative "./list.rb"

class Board
    attr_reader :id, :lists
    @@id_count = 0
    def initialize(name:, description:, id: nil, lists: [id:[], name:[], cards:[]])
        @id = id || @@id_count.next
        @@id_count = @id
        @name = name
        @description = description
        # @lista = lists
        # lists.empty? ?  @lists = List.new(lists) : @lists = lists.map{|list| List.new(list)}
        @lists = lists.map{|list| List.new(list)}

      end
      
      # def details
      #   cant_todo = @lists.select{|x| x.name == "Todo"}.count
      #   cant_inpro = @lists.select{|x| x.name == "In progress"}.count
      #   cant_code = @lists.select{|x| x.name == "Code Review"}.count
      #   cant_done = @lists.select{|x| x.name == "Done"}.count
      #   [@id, @name, @description, "Todo(#{cant_todo}), In Progress(#{cant_inpro}), Code Review(#{cant_code}), Done(#{cant_done})"]
      # end
    
      def details
        [@id, @name, @description, list_details]
      end
    
      def update(name:, description:)
        @name = name unless name.empty?
        @description = description unless description.empty?
      end
    
      def to_json(_generator)
        { id: @id, name: @name, description: @description, lists: @lists }.to_json
      end
    
      private
    
      def list_details
        lists = []
        @lists.each { |list| lists.push("#{list.name}(#{list.cards.size})") }
        lists.join(", ")
      end



end

# boar = Board.new
# pp boar.data