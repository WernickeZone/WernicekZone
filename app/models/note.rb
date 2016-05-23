class Note
  include Mongoid::Document
  field :note, type: Integer
  field :commentaire, type: String
  field :created_at, type: DateTime

  def self.new(note, commentaire = "")
    if (note >= 0 or note <= 5)
      self.note = note
      self.commentaire = commentaire
      self.created_at = DateTime.now
    end
  end
end
