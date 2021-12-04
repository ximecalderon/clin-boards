require "json"
require_relative "./list.rb"

class Board
  attr_reader :id, :lists
  @@id_count = 0
  def initialize(name:, description:, id: nil, lists: [])
    @id = id || @@id_count.next
    @@id_count = @id
    @name = name
    @description = description
    @lists = lists.map{|list| List.new(list)}
  end
  
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