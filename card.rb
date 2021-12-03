# require "store"

class Card

    @@id_count = 0
    attr_reader :title, :checklist, :id
    def initialize (id:, title:,  labels:[], due_date:, checklist:[{}], members:[])
     @id = id || @@id_count.next
     @@id_count = @id
     @labels = labels
     @due_date = due_date
     @checklist = checklist
     @title = title
     @members = members

    end

   

    def checklist_show
        count = 0
        @checklist.map{|checklist_data| count += 1 if checklist_data[:completed]}
        "#{count}/#{@checklist.size}"
    end 

    def details
        [@id, @title, @members.join(", "), @labels.join(", "), @due_date, checklist_show]
    end

    # def update(title:, artists:, album:, released:)
    #     @title = title unless title.empty?
    #     @artists = artists unless artists.empty?
    #     @album = album unless album.empty?
    #     @released = released.to_i unless released.empty?
    # end


    # private

    def to_json(_generator)
        { id: @id, title: @title, due_date: @due_date, labels: @labels,checklist: @checklist, members: @members }.to_json
    end


end

# git add .
# git commit -m "add base format"
# git push origin nombre-rama

