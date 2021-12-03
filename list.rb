# require_relative "Board"

class List
    def initialize(id:, name:, cards:)
        @id = id
        @name = name
        @cards = cards # [Cards1, Cards2]
    end

    # to_json
    # details [@id, @name, ...]


  
  
  
  
    
  private
  
    # def load_boar
    #     data = JSON.parse(File.read(@filename))
    #     data.map {|object| Board.new(object)}
    # end
  
  
  
  end