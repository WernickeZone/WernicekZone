# coding: utf-8
module LEXIQUE

  #Ouvre la base de données au format CSV
  def self.getCSV(fileName)
    if (fileName.nil? || fileName == '')
      return nil
    end
    require 'csv'
    csv = CSV.read(fileName, col_sep: ';')
    return csv
  end

  #Récupère la base du mot, exmemple: la base 'manger' pour le mot 'mangeons'
  def self.getWordBase(word, csv)
    if (word.nil? || word == '')
      return nil
    end
    base = csv.find { |row| row[0] == word }
    return base[1]
  end

  #Récupère la liste des mots correpsondant à la base, exemple: pour 'manger' => 'mange' 'manges' 'mangeons' 'mangez' 'mangent' etc.
  def self.getWordList(base, csv)
    if (base.nil? || base == '')
      return nil
    end
    list = csv.find_all { |row| row[1] == base }
    words = Array.new
    list.each { |row| words.push row[0] }
    return words
  end

  #Surcouche des fonctions précédentes récupèrant la liste complète des réponses possibles d'un mot donné
  def self.getAnswersList(word)
    if (word.nil? || word == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/Lexique380.csv')
    base = getWordBase(word, csv)
    wordList = getWordList(base, csv)
    return wordList
  end
  
  #Une surcouche de getWordbase
  def self.getWordBase2(word)
    if (word.nil? || word == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/Lexique380.csv')
    base = getWordBase(word, csv)
    return base
  end

  #output[0] Récupère le type d'un mot (NOM, VER, ADJ, ONO, AUX, ADJ)
  #output[1] Masculin ou feminin (f, m)
  #output[2] Singulier ou pluriel (s, p)
  def self.getWordInfos(word)
    if (word.nil? || word == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/Lexique380.csv')
    output = Array.new
    csv.find do |row|
      if row[0] == word
        output[0] = row[2]
        output[1] = row[3]
        output[2] = row[4]
      end
    end
    return output;
  end

  #Renvoie un tableau de la base de chaque mots tirés aléatoirement
  def self.getRandomWordsByType(type, fm, sp, number)
    if (type.nil? || type == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/Lexique380.csv')
    list = csv.find_all { |row| row[2] == type }
    output = Array.new
    while output.size < number
      rWord = list[rand(list.size)]
      if type == "VER"
        if rWord[2] == type
          output.push(rWord[1])
        end
      else
        if rWord[2] == type and rWord[3] == fm and rWord[4] == sp
          output.push(rWord[0])
        end
      end
    end
    return output;
  end
end

#Exemples 
include LEXIQUE
#puts LEXIQUE.getAnswersList("maison").inspect
