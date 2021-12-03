require "json"
require_relative "./board.rb"
require "terminal-table"
require_relative "store"

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

      action_id = menu(["Board options: create", "show ID", "update ID", "delete ID"])
      
      case action
      when "create" then puts "create action"
      when "update" then puts "update action"
      when "show" then puts "show action"
      when "delete" then puts "delete action"
      when "exit" then puts "Goodbye"
      else
        puts "Invalid action"
      end
    end
  end

  def print_table(list:, title:, headings:)
    table = Terminal::Table.new
    table.title = title
    table.headings = headings
    table.rows = list.map(&:details)
    puts table
  end

  def menu(options)
    puts options.join(" | ")
    puts "exit"
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

end

app = ClinBoards.new
app.start
