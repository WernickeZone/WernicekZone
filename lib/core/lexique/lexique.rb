module LEXIQUE
  def self.getCSV(fileName)
    if (fileName.nil? || fileName == '')
      return nil
    end
    require 'csv'
    csv = CSV.read(fileName, col_sep: ';')
    return csv
  end

  def self.getWordBase(word, csv)
    if (word.nil? || word == '')
      return nil
    end
    base = csv.find { |row| row[0] == word }
    return base[1]
  end

  def self.getWordList(base, csv)
    if (base.nil? || base == '')
      return nil
    end
    list = csv.find_all { |row| row[1] == base }
    words = Array.new
    list.each { |row| words.push row[0] }
    return words
  end

  def self.getAnswersList(word)
    if (word.nil? || word == '')
      return nil
    end
    csv = getCSV('lib/core/lexique/Lexique380.csv')
    base = getWordBase(word, csv)
    wordList = getWordList(base, csv)
    return wordList
  end

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
