require_relative "card"

class List
    attr_reader :cards, :name
    def initialize(id:, name:, cards:)
      @id = id
      @name = name
      # pp @cards = cards
      @cards = cards.map{|x| Card.new(x)}
    end

 


    def details
        


    end
  
  
    def to_json(_generator)
        { id: @id, name: @name, cards: @cards }.to_json
    end
  
    
  # private
  
 
  
  end