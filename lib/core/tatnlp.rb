# coding: utf-8
module TATNLP
  require 'treat'
  include Treat::Core::DSL

  #Désactive la detection du langage et force la langue française
  Treat.core.language.detect = false
  Treat.core.language.default = 'french'
  #Treat.core.language.default = 'english'

  #Fonction principale générant le texte à trous à partir du texte original (text) et, de la proportion de texte masqué (blanks)
  def self.generateTat(text, blanks)
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

  #Fonction permettant de vérifier les réponses de l'utilisateur
  def self.verifyAnswers(tat_answers, user_answers, errorLevel)
    is_right = Array.new
    i = 0

    #Parcoure la liste des réponses et fait les vérifications en fonction du niveau d'erreur
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

    #Renvoie un tableau contenant la liste des réponses
    return is_right
  end

  #Vérifie la grammaire d'un mot 
  def self.verifyLexique(tat_word, user_word)

    #Renvoie faux s'il manque une des valeurs
    if (tat_word.nil? || tat_word == '' || user_word.nil? || user_word == '')
      return "false"
    end

    #Renvoie vrai si les mots sont identiques
    if (tat_word == user_word)
      return "true"
    end

    #Importe le lexique et vérifie la grammaire du mot
    require 'core/lexique/lexique.rb'
    words = LEXIQUE.getAnswersList(tat_word)
    words.each do |word|
      if (word == user_word)
        return "true"
      end
    end
    
    return "false"
  end

  #Vérifie les synonymes d'un mot
  def self.verifySyns(tat_word, user_word)

    #Renvoie faux s'il manque une des valeurs
    if (tat_word.nil? || tat_word == '' || user_word.nil? || user_word == '')
      return "false"
    end

    #Renvoie vrai si les mots sont identiques
    if (tat_word == user_word)
      return "true"
    end

    #Importe la base des synonymes et le lexique
    #Vérifie la grammaire et les synonymes d'un mot
    require 'core/lexique/synonymes.rb'
    require 'core/lexique/lexique.rb'
    base = LEXIQUE.getWordBase(tat_word)
    syns = SYN.getSynonyms(base)
    if syns.nil?
      return "false"
    end
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
