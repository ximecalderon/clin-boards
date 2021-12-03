require "json"
require_relative "board"

class Store
  attr_reader :boards 

  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  def add_board(new_board)
    @boards.push(new_board)
    save
  end

  def find_board(id)
    @boards.find { |pl| pl.id == id }
  end

  private

  def load_board
    data = JSON.parse(File.read(@filename), { symbolize_names: true })
    data.map {|board_data| Board.new(board_data)}
  end

  def save
    File.write(@filename, @boards.to_json)
  end
end
