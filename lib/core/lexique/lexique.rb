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
end

#Exemples 
include LEXIQUE
#puts LEXIQUE.getAnswersList("maison").inspect
