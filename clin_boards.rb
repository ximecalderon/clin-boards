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
      print_table(list: @store.boards,
                  title: "CLIn Boards",
                  headings: ["ID", "Name", "Description", "List(#cards)"])

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
    board = @store.find_board(id)
    item = board.lists.map{|x| x.name}
    todo = board.lists.find{|x| x.name == "Todo"}
    in_progress = board.lists.find{|x| x.name == "In Progress"}
    code_review = board.lists.find{|x| x.name == "Code Review"}
    done = board.lists.find{|x| x.name == "Done"}

      print_table(list: todo.cards,
                  title: "Todo",
                  headings: %w[ID Title Members Labels Due_Date Checklist])
      
                  print_table(list: in_progress.cards,
                  title: "In Progres",
                  headings: %w[ID Title Members Labels Due_Date Checklist])
      
                  print_table(list: code_review.cards,
                  title: "Code  Review",
                  headings: %w[ID Title Members Labels Due_Date Checklist])
                  
                  print_table(list: done.cards,
                  title: "Done",
                  headings: %w[ID Title Members Labels Due_Date Checklist])


      action, id = menu2("List options: create-list | update-list LISTNAME |delete-list ID\nCard options: create-card | checklist ID | update-car ID | delete-card\n back")

      case action
      when "create" then create_song(playlist)
      when "update" then update_song(id, playlist)
      when "delete" then delete_song(id, playlist)
      when "back" then next
      when "create" then create_song(playlist)
      when "update" then update_song(id, playlist)
      when "delete" then delete_song(id, playlist)
      when "back" then next
      else
        puts "Invalid action"
      end
    end

  end


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

  def update

  end

  def show

  end

  def delete
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
    puts "exit"
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

end

app = ClinBoards.new
app.start
