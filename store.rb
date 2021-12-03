require "json"
require_relative "board"

class Store
  attr_reader :boards

  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  

  private

  def load_board
    data = JSON.parse(File.read(@filename), { symbolize_names: true })
    data.map {|board_data| Board.new(board_data)}
  end

  def load_list
  end
  def load_card
  end
end
