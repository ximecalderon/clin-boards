require "json"
require_relative "./board.rb"

class ClinBoards

  def initialize(filename)
    @filename = filename
  end

  def start
    store = JSON.parse(File.read(@filename), { symbolize_names: true })
    @board = store.map{|data| Board.new(data)}
    # pp lists
    # pp board
    pp board.data
    
    


    puts "#{'#'*40}"
    puts "#      Welcome to CLIn Boards      # "
    puts "#{'#'*40}"

    # print_table(list: ,
    #   title: "Music CLImax",
    #   headings: ["ID", "List", "Description", "#Songs"])

    
# #case (opcione)

#     #create(name, description  ) 
    
#     #show(id)


#     #update(id)


#     #delete(id)

  end
#   end

# #def create

# #def show
# #.
# #.
# #.


end
# sss
# get the command-line arguments if neccesary
app = ClinBoards.new("store.json")
app.start