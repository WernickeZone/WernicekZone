class Contact
  include Mongoid::Document
  field :nom, type: String
  field :email, type: String
  field :message, type: String
end
