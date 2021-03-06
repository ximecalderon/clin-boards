require "json"
require_relative "board"
require "terminal-table"
require_relative "store"
require "colorize"

class ClinBoards
  def initialize
    @store = Store.new("store.json")
  end

  def start
    puts "####################################".colorize(color: :light_blue, background: :pink)
    puts "#      Welcome to CLIn Boards      #".colorize(color: :light_blue, background: :pink)
    puts "####################################".colorize(color: :light_blue, background: :pink)

    action = ""
    until action == "exit"
      print_table(list: @store.boards, title: "CLIn Boards", headings: ["ID", "Name", "Description", "List(#cards)"])
      action, id = menu(["Board options: create", "show ID", "update ID", "delete ID"], nil, "exit")

      case action
      when "create" then create_board
      when "update" then update_board(id)
      when "show" then show_list(id)
      when "delete" then delete_board(id)
      when "exit" then puts "Goodbye"
      else
        puts "Invalid action"
      end
    end
  end

  private

  def show_list(id)
    @board = @store.find_board(id)
    # @name_list = []
    # @board.lists.each { |list| @name_list.push(list.name) }
    action = ""
    until action == "back"
      @board.lists.each do |list|
        print_table(list: list.cards,
                    title: list.name,
                    headings: ["ID", "Title", "Members", "Labels", "Due Date", "Checklist"])
      end
      action, id = menu(["List options: create-list", "update-list LISTNAME", "delete-list LISTNAME"],
                        ["Card options: create-card", "checklist ID", "update-card ID", "delete-card ID"],
                        "back")

      case action
      when "create-list" then create_list(@board)
      when "update-list" then update_list(id, @board)
      when "delete-list" then delete_list(id, @board)
      when "create-card" then create_card
      when "checklist" then checklist_id(id)
      when "delete-card" then delete_card(id)
      when "update-card" then update_card(id)
      when "back" then break
      else puts "Invalid action"
      end
    end
  end

  # ------------ Board methods ------------

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end

  def create_board
    board_data = board_form
    new_board = Board.new(board_data)
    @store.add_board(new_board)
  end

  def update_board(id)
    new_data = board_form
    @store.update_board(id, new_data)
  end

  def delete_board(id)
    @store.delete_board(id)
  end

  # ------------ List methods ------------

  def list_form
    print "Name: "
    name = gets.chomp
    { name: name }
  end

  def create_list(board)
    list_data = list_form
    new_list = List.new(list_data)
    @store.create_list(new_list, board)
  end

  def update_list(name, board)
    new_data = list_form
    @store.update_list(name, new_data, board)
  end

  def delete_list(name, board)
    @store.delete_list(name, board)
  end

  #-------------------------------cards ---------------------------------------
  
  def print_name_list
    input = ""
    lists = []
    @board.lists.each { |list| lists.push(list.name) }

    until lists.include? input
      print "Select a list:"
      print lists.join(" | ")
      puts ""
      input = gets.chomp
    end
    input
  end

  def create_card
    name_list = print_name_list
    container = @board.lists.find { |x| x.name == name_list }.cards
    new_card = Card.new(card_data)
    container.push(new_card)
    @store.save
  end

  def delete_card(id_card)
    @board.lists.map { |x| x.cards.reject! { |y| y.id == id_card } }.reject(&:nil?)[0]
    @store.save
  end

  def update_card(id_card)
    list_name = print_name_list
    list_container = @board.lists.find { |list| list.cards.any? { |card| card.id == id_card } }
    card =
      @board.lists.map do |list|
        list.cards.find do |card_|
          card_.id == id_card
        end
      end.reject(&:nil?)[0]
    update_data = card_data
    card.title = update_data[:title] unless update_data[:title].empty?
    card.members = update_data[:members] unless update_data[:members].empty?
    card.labels = update_data[:labels] unless update_data[:labels].empty?
    card.due_date = update_data[:due_date] unless update_data[:due_date].empty?

    if list_name != list_container.name
      container = @board.lists.find { |list| list.name == list_name }.cards # contenedor card destino
      # elimina el objeto del contenedor destino
      @board.lists.map do |x|
        x.cards.reject! do |y|
          y.id == id_card
        end
      end.reject(&:nil?)[0]
      container.push(card)
    end

    @store.save
  end

  #------------------  Checklist   -----------------------------

  def checklist_id(id_card)
    @container_card = @board.lists.map { |x| x.cards.find { |y| y.id == id_card } }.reject(&:nil?)[0]
    panel_checklist

    accion = ""
    until accion == "back"
      accion, index = menu(["Board options: add", "toggle INDEX", "delete INDEX"], nil, "back")
      puts accion
      case accion
      when "add" then add_checklist
      when "toggle" then toggle_checklist(index)
      when "delete" then delete_checklist(index)
      when "back" then next
      else puts "accion invalid"
      end
    end
  end

  def add_checklist
    print "Title:"
    title = gets.chomp
    @container_card.checklist.push({ title: title, completed: false })
    @store.save
    panel_checklist
  end

  def toggle_checklist(index)
    @container_card.checklist.map.with_index { |x, i| x[:completed] = !x[:completed] if (i + 1) == index }
    @store.save
    panel_checklist
  end

  def delete_checklist(index)
    @container_card.checklist.reject!.with_index { |_x, i| i + 1 == index }
    @store.save
    panel_checklist
  end

  def panel_checklist
    puts ("-" * 40).to_s
    puts @container_card.title
    @container_card.checklist.map.with_index do |x, i|
      x[:completed] ? (a = "x") : (a = " ")
      puts "[#{a}] #{i + 1}. #{x[:title]}"
    end
    puts ("-" * 40).to_s
  end

  #------------------------ Fin Checklist ------------------------------------------------

  def menu(options_line1, options_line2 = nil, exit_back)
    puts options_line1.join(" | ")
    puts options_line2.join(" | ") unless options_line2.nil?
    puts exit_back
    print "> "
    input = gets.chomp.split
    action = input[0]
    id = input[1..].join(" ")

    if !id.nil? && id.match(/^\d+$/)
      [action, id.to_i]
    else
      [action, id]
    end
  end

  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = (list.map(&:details))
    table.style = { border: :unicode_thick_edge }
    puts table
  end

  def card_data
    info = ["Title:", "Members:", "Labels:", "Due Date:"]
    datos = []
    4.times do |index|
      print info[index]
      datos.push(gets.chomp)
    end
    { id: nil, title: datos[0], labels: [datos[2]], due_date: datos[3], checklist: [], members: datos[1].split }
  end
end

app = ClinBoards.new
app.start
