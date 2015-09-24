# coding: utf-8
module SYN

  #Récupère la base de données au format CSV
  def self.getCSV(fileName)
    if (fileName.nil? || fileName == '')
      return nil
    end
    require 'csv'
    csv = CSV.read(fileName, col_sep: ';')
    return csv
  end

  #Récupère la liste des synonymes d'un mot en question
  def self.getWordList(word, csv)
    if (word.nil? || word == '')
      return nil
    end
    words = csv.find { |row| row[0] == word }
    return words
  end

  #Cette fonction remet la liste des mots en forme
  def self.cleanWordList(wordList)
    if (wordList.nil?)
      return nil
    end
    words = Array.new
    wordList.each do |word|
      if (word.nil?)
        return words
      else
        words.push word
      end
    end
    return words
  end

  #Surcouche des fonctions précédentes et récuperant la liste complète des synonymes
  def self.getSynonyms(word)
    if (word.nil? || word == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/thes_fr.csv')
    wordList = getWordList(word, csv)
    wordList = cleanWordList(wordList)
    return wordList
  end
end

#Exemples 
include SYN
#syns = SYN.getSynonyms("afin")
#puts syns.inspect
