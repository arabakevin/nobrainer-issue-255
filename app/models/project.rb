# frozen_string_literal: true

puts 'Loading Project model ...'

class Project
  include NoBrainer::Document
  include NoBrainer::Document::Timestamps

  # ~~~~ Fieds ~~~~~
  field :name, type: String, required: true, uniq: { scope: :organisation_id }
  field :organisation_id, type: String

  # ~~~~ Associations ~~~~
  belongs_to :organisation

  # Simple index
  index :name
end
