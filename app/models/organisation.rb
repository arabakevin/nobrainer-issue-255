# frozen_string_literal: true

puts 'Loading Organisation model ...'

class Organisation
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  # ~~~~ Fieds ~~~~~
  field :name, type: String, uniq: true, required: true

  # ~~~~ Associations ~~~~
  has_many :projects

  # Simple index
  index :name
end
