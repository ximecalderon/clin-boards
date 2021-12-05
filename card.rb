# require "store"

class Card
  attr_accessor :id, :title, :labels, :due_date, :checklist, :members

  @@id_count_card = 0
  def initialize(id:, title:, due_date:, labels: [], checklist: [{}], members: [])
    @id = id.nil? ? @@id_count_card.next : id
    @@id_count_card = @id
    @labels = labels
    @due_date = due_date
    @checklist = checklist
    @title = title
    @members = members
  end

  def checklist_show
    count = 0
    @checklist.map { |checklist_data| count += 1 if checklist_data[:completed] }
    "#{count}/#{@checklist.size}"
  end

  def details
    [@id, @title, @members.join(", "), @labels.join(", "), @due_date, checklist_show]
  end

  def to_json(_generator)
    { id: @id, title: @title, due_date: @due_date, labels: @labels, checklist: @checklist,
      members: @members }.to_json
  end
end
