# coding: utf-8
module LEXIQUE

  #Instancie la classe Lexique servant d'interface à la collection Lexiques
  class Lexique
    include Mongoid::Document
    store_in database: "nlp", collection: "Lexiques"
  
    field :mot, type: String
    field :infinitif, type: String
    field :type, type: String
    field :genre, type: String
    field :nombre, type: String

    attr_readonly :mot, :infinitif, :type, :genre, :nombre
  end

  #Récupère la base du mot, exmemple: la base 'manger' pour le mot 'mangeons'
  def self.getWordBase(word)
    if (word.nil? || word == '')
      return nil
    end
    lex = Lexique.find_by(mot: word)
    return lex.infinitif
  end

  #Récupère la liste des mots correpsondant à la base, exemple: pour 'manger' => 'mange' 'manges' 'mangeons' 'mangez' 'mangent' etc.
  def self.getWordList(base)
    if (base.nil? || base == '')
      return nil
    end
    lex = Lexique.where(infinitif: base)
    output = Array.new
    lex.each do |l|
      output.push l.mot
    end
    return output
  end

  #Surcouche des fonctions précédentes récupèrant la liste complète des réponses possibles d'un mot donné
  def self.getAnswersList(word)
    if (word.nil? || word == '')
      return nil
    end
    base = getWordBase(word)
    wordList = getWordList(base)
    return wordList
  end
  
  #output[0] Récupère le type d'un mot (NOM, VER, ADJ, ONO, AUX, ADJ)
  #output[1] Masculin ou feminin (f, m)
  #output[2] Singulier ou pluriel (s, p)
  def self.getWordInfos(word)
    if (word.nil? || word == '')
      return nil
    end
    lex = Lexique.find_by(mot: word)
    output = Array.new
    output[0] = lex.type
    output[1] = lex.genre
    output[2] = lex.nombre
    return output;
  end

  #Renvoie un tableau de la base de chaque mots tirés aléatoirement
  def self.getRandomWordsByType(type, fm, sp, number)
    if (type.nil? || type == '')
      return nil
    end
    lex = Lexique.where(type: type)
    output = Array.new
    while output.size < number
      rLex = lex[rand(lex.count)]
      if type == "VER"
        if rLex.type == type
          output.push(rLex.infinitif)
        end
      else
        if rLex.type == type and rLex.genre == fm and rLex.nombre == sp
          output.push(rLex.mot)
        end
      end
    end
    return output;
  end
end

#Exemples 
include LEXIQUE
#puts LEXIQUE.getAnswersList("maison").inspect
