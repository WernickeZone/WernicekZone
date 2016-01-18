class Qcm
  include Mongoid::Document
  
  field :fullText, :type => String
  field :step, :type => String
  field :qcm_content, :type => String
  field :qcm_answers, :type => String
  field :qcm_choices, :type => String
  field :user_answers, :type => String
  field :is_right, :type => String
end
