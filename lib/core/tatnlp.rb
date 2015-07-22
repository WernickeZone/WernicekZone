# coding: utf-8
module TATNLP
  require 'treat'
  include Treat::Core::DSL
  Treat.core.language.detect = false
  Treat.core.language.default = 'french'
  #Treat.core.language.default = 'english'
  def TATNLP.generateTat(text, blanks, error)
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
    if error == '0'
      return output
    else
      return output
    end
    #Error1 Ajout des synonymes
    #Error2 Hypernymes
    #Error3 Correction orthographique légère
    #puts YAML::dump(input)
  end
end
#####How to use it
include TATNLP
###Le include TATNLP est necessaire ici, et je ne comprend pas pourquoi.
#texte = 'Bonjour, je suis la reine des neiges.'
#texte = 'This is a fucking text.Deal with it'
#content = TATNLP.generateTat(texte,'50%','1')
#require 'yaml'
#puts YAML::dump(content)
