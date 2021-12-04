require "json"
require_relative "board.rb"
require "terminal-table"
require_relative "store.rb"

class ClinBoards

  def initialize
    @store = Store.new("store.json")
  end
  
  def start
    puts "####################################"
    puts "#      Welcome to CLIn Boards      #"
    puts "####################################"

    action = ""
    until action == "exit"
      print_table(list: @store.boards, title: "CLIn Boards", headings: ["ID", "Name", "Description", "List(#cards)"])
      action, id = menu(["Board options: create", "show ID", "update ID", "delete ID"])
      
      case action
      when "create" then puts create_board
      when "update" then puts "update action"
      when "show" then puts show_list(id)
      when "delete" then puts "delete action"
      when "exit" then puts "Goodbye"
      else
        puts "Invalid action"
      end
    end
  end

  def show_list(id)
    @board = @store.find_board(id)
    item = @board.lists.map{|x| x.name}
    todo = @board.lists.find{|x| x.name == "Todo"}
    in_progress = @board.lists.find{|x| x.name == "In Progress"}
    code_review = @board.lists.find{|x| x.name == "Code Review"}
    done = @board.lists.find{|x| x.name == "Done"}

    print_table(list: todo.cards, title: "Todo", headings: %w[ID Title Members Labels Due_Date Checklist])
    print_table(list: in_progress.cards, title: "In Progres", headings: %w[ID Title Members Labels Due_Date Checklist])
    print_table(list: code_review.cards, title: "Code  Review", headings: %w[ID Title Members Labels Due_Date Checklist])
    print_table(list: done.cards, title: "Done", headings: %w[ID Title Members Labels Due_Date Checklist])

    action, id = menu2("List options: create-list | update-list LISTNAME |delete-list ID\nCard options: create card | checklist ID | update-car ID | delete-card\n back")

    case action
    when "create-card" then create_card
    when "checklist-id" then checklist_id(id)
    # when "delete" then delete_song(id, playlist)
    # when "create" then create_song(playlist)
    # when "update" then update_song(id, playlist)
    # when "delete" then delete_song(id, playlist)
    else puts "Invalid action"
    end

  end

  def board_form
    print "Name: "
    name = gets.chomp
    print "Description: "
    description = gets.chomp
    { name: name, description: description }
  end

  def create_card
    print "Select a list:"
    puts "Todo | In Progress | Code Review | Done"
    select_list = gets.chomp
    container = @board.lists.find{|x| x.name == "#{select_list}"}.cards
    new_card = Card.new(get_data_card)
    container.push(new_card)
    @store.save
  end
  
  #------------------  Checklist   -----------------------------
  def checklist_id(id_card)
    @container_card = @board.lists.map{|x| (x.cards).find{|y| y.id == id_card}}.reject(&:nil?)[0]
    panel_checklist

    accion = ""
    until accion == "exit"
      accion, index = menu(["Board options: add", "toggle INDEX", "delete INDEX"])
      puts accion
      case accion
      when "add" then add_checklist
      when "toggle" then toggle_checklist(index)
      when "delete" then delete_checklist(index)
      else puts "accion invalid"
      end
    end
  end

  def add_checklist
    print "Title:"
    title = gets.chomp
    @container_card.checklist.push({title: title, completed: false})
    @store.save
    panel_checklist
  end
  
  def toggle_checklist(index)
    @container_card.checklist.map.with_index{|x, i| x[:completed] = !x[:completed]  if (i + 1) == index}
    @store.save
    panel_checklist
  end

  def delete_checklist(index)
    @container_card.checklist.reject!.with_index{|_x, i| i + 1 == index}
    @store.save
    panel_checklist
  end

  def panel_checklist
    puts "#{'-' * 40}"
    puts @container_card.title
    @container_card.checklist.map.with_index do |x, i|
      x[:completed] ? (a = "x") : (a = " ")
      puts "[#{a}] #{i+1}. #{x[:title]}"
    end
    puts "#{'-'*40}"
  end

  #------------------------ Fin Checklist ------------------------------------------------

  private
  def get_data_card
    info = ["Title:", "Members:", "Labels:", "Due Date:"]
    datos = []
    4.times do |index|
      print info[index]
      datos.push(gets.chomp)
    end
    {id: nil, title: datos[0], labels: [datos[2]], due_date: datos[3], checklist: [], members: datos[1].split}
  end
  
  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    # table.rows = list
    puts table
  end

  def menu(options)
    puts options.join(" | ")
    puts "exit"
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

  def menu2(options)
    puts options
    puts "back"
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

end

app = ClinBoards.new
app.start
