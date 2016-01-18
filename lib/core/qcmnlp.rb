# coding: utf-8
module QCMNlp
  require 'core/lexique/lexique.rb'
  require 'core/lexique/verbs.rb'

  require 'treat'
  include Treat::Core::DSL

  #Désactive la detection du langage et force la langue française
  Treat.core.language.detect = false
  Treat.core.language.default = 'french'
  #Treat.core.language.default = 'english'

  #Génère les différentes réponses du QCM
  def self.generateAnswers(word)
    if word == '' or word.nil?
      return nil
    end
    infos = LEXIQUE.getWordInfos(word)
    output = Array.new
    if infos[0] == "VER"
      deconj = VERBS.deconjugator(word)
      rWord = LEXIQUE.getRandomWordsByType("VER",'','',2)
      output[0] = VERBS.conjugator(rWord[0],deconj[1],deconj[2],deconj[3],deconj[4])
      output[1] = VERBS.conjugator(rWord[1],deconj[1],deconj[2],deconj[3],deconj[4])
    else
      output = LEXIQUE.getRandomWordsByType(infos[0],infos[1],infos[2],2)
    end
    return output
  end

  #Fonction principale générant le QCM à partir du texte original (text) et, de la proportion de texte masqué (blanks)
  #Renvoi un talbeau contenant le texte segmenté en ouput[0]
  #En ouput[1] les différents mots
  def self.generateQCM(text, blanks)
    #Contrôle si un texte est bien envoyé en entrée
    if (text.nil?)
      return nil
    end

    #Contrôle si le texte se termine bien par un signe de ponctuation
    if (text[text.length - 1] != '.' || text[text.length - 1] != '!' || text[text.length - 1] != '?')
      text[text.length] = '.'
    end
    
    #Initialisation des variables et segmentation du texte (en phrases, mots etc.)
    input = paragraph text
    input.apply(:chunk, :segment, :tokenize)
    blank = blanks[0].to_i * 10
    tmpStr = ""
    res = Hash.new
    output = Array.new(2) { Array.new Array.new }

    #Parcoure les phrases
    input.sentences.each do |a|
      hidden = 0
      total = 0
      length = 0

      #Stocke la longueur de mot maximale de la phrase
      a.words.each do |b|
        if length < b.to_s.length
          length = b.to_s.length
        end
      end

      #Mets les mots à cacher dans un tableau indexé par l'emplacement du mot dans la phrase
      while (total < blank && length > 0)
        a.words.each do |b|
          if total < blank
            if (b.to_s.length == length) and (!!b.to_s.match(/^[[:alnum:]]+$/) == true)
              hidden += 1
              res[b.id.to_s] = b.value
            end
          end
          total = (hidden.to_f / a.words.count) * 100
        end
        length -= 1
      end

      #Remet les résultats dans l'ordre non pas par longueur de mot, mais par ordre d'apparition dans le texte
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

    #Crée une case supplémentaire dans le tableau (output[0][n+1]) pour avoir le même nombre de cases entre output[0] et output[1]
    output[0].push tmpStr
    return output
  end

end

#####How to use it
include QCMNlp
###Le include QMCNlp est necessaire ici.
#texte = 'Bonjour, je suis la reine daesh.'
#content = QCMNlp.generateQCM(texte,'50%')
