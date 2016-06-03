# coding: utf-8
module SYN

  #Instancie la classe Synonyme servant d'interface à la collection Synonymes
  class Synonyme
    include Mongoid::Document
    store_in database: "nlp", collection: "Synonymes"
    field :mot, type: String

    for i in 1..186 do
      name = "syn" + i.to_s
      field name.to_sym, type: String
    end
    
    attr_readonly :mot    
  end
  
  #Récupère la liste des synonymes d'un mot en question
  def self.getWordList(word)
    if (word.nil? || word == '')
      return nil
    end
    syn = Synonyme.find_by(mot: word)
    if syn.nil?
      return nil
    end
    output = Array.new
    for i in 1..186 do
      name="syn"+i.to_s
      if (syn.mot.nil? or syn.mot == '')
        return output
      else
        output.push(syn.send(name))
      end
    end
    return output
  end

  #Surcouche des fonctions précédentes et récuperant la liste complète des synonymes
  def self.getSynonyms(word)
    if (word.nil? || word == '')
      return nil
    end
    wordList = getWordList(word)
    return wordList
  end
end

#Exemples 
include SYN
#syns = SYN.getSynonyms("afin")
#puts syns.inspect
