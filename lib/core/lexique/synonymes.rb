# coding: utf-8
module SYN
  def self.getCSV(fileName)
    if (fileName.nil? || fileName == '')
      return nil
    end
    require 'csv'
    csv = CSV.read(fileName, col_sep: ';')
    return csv
  end

  def self.getWordList(word, csv)
    if (word.nil? || word == '')
      return nil
    end
    words = csv.find { |row| row[0] == word }
    return words
  end

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
