require "json"
require_relative "board"

class Store
  attr_reader :boards

  def initialize(filename)
    @filename = filename
    @boards = load_board
  end

  # ------------ Board methods ------------

  def add_board(new_board)
    @boards.push(new_board)
    save
  end

  def update_board(id, data)
    board = find_board(id)
    board.update(data)
    save
  end

  def delete_board(id)
    board = find_board(id)
    @boards.delete(board)
    save
  end

  def find_board(id)
    @boards.find { |board| board.id == id }
  end

  # ------------ List methods ------------

  def create_list(new_list, board)
    board.lists.push(new_list)
    save
  end

  def update_list(name, new_data, board)
    list = find_list(name, board)
    list.update(new_data)
    save
  end

  def delete_list(name, board)
    board.lists.delete_if { |list| list.name == name }
    save
  end

  def find_list(name, board)
    board.lists.find { |list| list.name == name }
  end

  # private

  def load_board
    data = JSON.parse(File.read(@filename), { symbolize_names: true })
    data.map { |board_data| Board.new(board_data) }
  end

  def save
    File.write(@filename, @boards.to_json)
  end
end
