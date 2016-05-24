class Note
  include Mongoid::Document
  field :note, type: Integer
  field :commentaire, type: String
  field :created_at, type: DateTime
  
  validates :note, :presence => true

  
end
