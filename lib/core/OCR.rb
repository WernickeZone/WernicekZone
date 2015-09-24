# coding: utf-8
module OCR
  require 'ffi/aspell'
  require 'rtesseract'
  require 'rmagick'
  include Magick

  #Reconnaissance optique de caractères
  #Récupère le texte d'un fichier image
  def self.translate(name)

    #Le fichier étant créé avec un nom aléatoire, le renomer
    File.rename(name.tempfile, '/tmp/' + name.original_filename);
    file = File.open('/tmp/' + name.original_filename, 'r+');

    #Ouvre le fichier avec l'outil de manipulation d'images
    rmagick = ImageList.new(file)
    width = rmagick.columns
    height = rmagick.rows
    rmagick = rmagick.resample(width, height)
    
    rmagick.write(file) { self.quality = 100 }

    #Ouvre le fichier avec l'outil de reconnaissance optique de caractères
    image = RTesseract.new(file)
    string = image.to_s
    temp = string
    
    speller = FFI::Aspell::Speller.new('fr')

    #Vérifie les mots à l'aide du dictionnaire
    string.gsub(/[^\s(),\.!?&@%]+/) do |word|
      if !speller.correct?(word)
        # word is wrong
        test = word.upcase
        temp = temp.gsub("#{word}", "#{test}")
      end
    end

    #Efface le fichier temporaire
    File.delete file
    return temp
  end

end
