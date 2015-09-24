# coding: utf-8
module Dict
  require 'ffi/aspell'

  #Vérifie si un mot est présent dans le dictionnaire
  def self.isRight?(word)
    speller = FFI::Aspell::Speller.new('fr')
    if speller.correct?(word)
      return true
    else
      return false
    end
    speller.close
  end
end
