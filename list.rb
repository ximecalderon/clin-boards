require "json" # no estaba
require_relative "card"

class List
  @@id_count_lits = 0
  attr_reader :cards, :name
  def initialize(id: nil , name:, cards:[])
    id.nil? ? @id = @@id_count_list.next : @id = id 
    @@id_count_list = @id
    @name = name
    @cards = cards.map{|x| Card.new(x)}
  end

  def update(name:)
    @name = name unless name.empty?
  end

  def to_json(_generator)
    { id: @id, name: @name, cards: @cards }.to_json
  end
end