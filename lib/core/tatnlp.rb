# coding: utf-8
module TATNLP
  require 'treat'
  include Treat::Core::DSL
  Treat.core.language.detect = false
  Treat.core.language.default = 'french'
  #Treat.core.language.default = 'english'

  def self.generateTat(text, blanks)
    if (text.nil?)
      return nil
    end
    if (text[text.length - 1] != '.' || text[text.length - 1] != '!' || text[text.length - 1] != '?')
      text[text.length] = '.'
    end
    input = paragraph text
    input.apply(:chunk, :segment, :tokenize)
    blank = blanks[0].to_i * 10
    tmpStr = ""
    res = Hash.new
    output = Array.new(2) { Array.new Array.new }
    input.sentences.each do |a|
      hidden = 0
      total = 0
      length = 0
      a.words.each do |b|
        if length < b.to_s.length
          length = b.to_s.length
        end
      end
      while (total < blank && length > 0)
        a.words.each do |b|
          if total < blank
            if b.to_s.length == length
              hidden += 1
              res[b.id.to_s] = b.value
            end
          end
          total = (hidden.to_f / a.words.count) * 100
        end
        length -= 1
      end
      a.each do |b|
        if res[b.id.to_s].nil?
          if b.type == :word
            tmpStr << " " + b.value
          else
            tmpStr << b.value
          end
        else
          output[0].push tmpStr
          tmpStr = ""
          output[1].push b.value
        end
      end
    end
    output[0].push tmpStr
    return output
  end

  def self.verifyAnswers(tat_answers, user_answers, errorLevel)
    is_right = Array.new
    i = 0
    tat_answers.each do |a|
      bool = "false"
      if (errorLevel == '0')
        if (a.downcase == user_answers[i].downcase)
          bool = "true"
        end
      elsif (errorLevel == '1')
        if (verifyLexique(a.downcase, user_answers[i].downcase) == "true")
          bool = "true"
        end
      elsif (errorLevel == '2')
        if (verifySyns(a.downcase, user_answers[i].downcase) == "true")
          bool = "true"
        end
      end
      is_right.push bool
      i = i + 1
    end
    return is_right
  end

  def self.verifyLexique(tat_word, user_word)
    if (tat_word.nil? || tat_word == '' || user_word.nil? || user_word == '')
      return "false"
    end
    if (tat_word == user_word)
      return "true"
    end
    require 'core/lexique/lexique.rb'
    words = LEXIQUE.getAnswersList(tat_word)
    words.each do |word|
      if (word == user_word)
        return "true"
      end
    end
    return "false"
  end

  def self.verifySyns(tat_word, user_word)
    if (tat_word.nil? || tat_word == '' || user_word.nil? || user_word == '')
      return "false"
    end
    if (tat_word == user_word)
      return "true"
    end
    
    require 'core/lexique/synonymes.rb'
    require 'core/lexique/lexique.rb'
    base = LEXIQUE.getWordBase2(tat_word)
    syns = SYN.getSynonyms(base)
    syns.each do |syn|
      if (verifyLexique(syn, user_word) == "true")
        return "true"
      end
    end
    return "false"
  end
end

#####How to use it
include TATNLP
###Le include TATNLP est necessaire ici, et je ne comprend pas pourquoi.
#texte = 'Bonjour, je suis la reine daesh.'
#content = TATNLP.generateTat(texte,'50%','1')
####Marge d'erreur
#0 => Aucune erreur
#1 => Erreurs singulier/pluriel ou conjugaison si verbe
#2 => Niveau 1 + Synonymes autorisés
