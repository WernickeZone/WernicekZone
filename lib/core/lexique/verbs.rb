# coding: utf-8
module VERBS
  #Utilise le programme Verbiste.
  
  #Récupère les infos d'un verbe
  def self.deconjugator(verb)
    command = `french-deconjugator #{verb}`
    command.gsub!(/\r\n?/, "\n")
    output = command.split(", ")
    #Tableau de sortie (infinitif, mode, temps, personne, singulier/pluriel)
  end

  #Conjugue un verbe
  def self.conjugator(infinitive, mode, tense, person, plural)
    command = `french-conjugator #{infinitive} --mode=#{mode} --tense=#{tense}`
    command.gsub!(/\r\n?/, "\n")
    line_count = 0
    person_i = person.to_i
    if plural.include? "plural"
      person_i += 3
    end
    command.each_line do |line|
      if line_count == person_i
        return line
      end
      line_count += 1
    end
    return nil;
  end
end

#HOW TO USE IT
#require './verbs.rb'
#verb = VERBS.deconjugator("marchaient")
#verb2 = VERBS.conjugator(verb[0],verb[1],verb[2],verb[3],verb[4])
#puts verb2
#verb.each do |row|
#  puts row
#end
