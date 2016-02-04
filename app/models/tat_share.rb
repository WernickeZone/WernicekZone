class TatShare
  include Mongoid::Document
  field :fullText, type: String
  field :tat_content, type: String
  field :tat_answers, type: String
end
