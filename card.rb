# require "store"

class Card

    @@id_count = 0
    attr_reader :title
    def initialize (id:, title:,  labels:, due_date:, checklist:, members:)
     @id = id || @@id_count.next
     @@id_count = @id
     @labels = labels
     @due_date = due_date
     @checklist = checklist
     @title = title
     @members = members

    end

    def details
        [@id, @title, @members.join(", "), @labels.join(", "), @due_date, "holi"]
    end

    # def create_card
    #     print "Select a list:"
    #     puts "Todo | In Progress | Code Review | Done"
    #     select_list = gets.chomp
    #     print "Title:" 
    #     @title = gets.chomp
    #     print "Members:"
    #     @members = gets.chomp
    #     print "Labels:"
    #     @labels = gets.chomp
    #     print "Due Date:"
    #     @due_date = gets.chomp 

    # end

    # def update(title:, artists:, album:, released:)
    #     @title = title unless title.empty?
    #     @artists = artists unless artists.empty?
    #     @album = album unless album.empty?
    #     @released = released.to_i unless released.empty?
    # end


    # private

    # def to_json(_generator)
    #     { id: @id, title: @title, Members: @Members, due_date: @due_date, @checklist = checklist }.to_json
    # end


end

# git add .
# git commit -m "add base format"
# git push origin nombre-rama

