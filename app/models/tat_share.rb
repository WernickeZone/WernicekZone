class Tat_share
  include Mongoid::Document
  field :fullText, type: String
  field :tat_content, type: String
  field :tat_answers, type: String
  field :error_margin, type: String
  field :hidden_text, type: String
end
