module OCR
  
  require 'ffi/aspell'
  require 'rtesseract'
  require 'rmagick'
  include Magick
  
  def OCR.translate(name)
    File.rename(name.tempfile, '/tmp/' + name.original_filename);
    file = File.open('/tmp/' + name.original_filename, 'r+');
    rmagick = ImageList.new(file)
    width = rmagick.columns
    height = rmagick.rows
    rmagick = rmagick.resample(width, height)
    
    rmagick.write(file) { self.quality = 100 }

    image = RTesseract.new(file)
    string = image.to_s
    temp = string
    speller = FFI::Aspell::Speller.new('fr')
    
    string.gsub(/[^\s(),\.!?&@%]+/) do |word|
      if !speller.correct?(word)
        # word is wrong
        test = word.upcase
        temp = temp.gsub("#{word}", "#{test}")
      end
    end
    return temp
  end
end
