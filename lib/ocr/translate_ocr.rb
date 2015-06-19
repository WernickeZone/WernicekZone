# coding: utf-8
require 'ffi/aspell'
require 'rtesseract'
require 'rmagick'

include Magick

rmagick = ImageList.new("test.png")

width = rmagick.columns
height = rmagick.rows

width = width * 2
height = height * 2

rmagick = rmagick.resample(width, height)

rmagick.write("text.png") { self.quality = 100 }

image = RTesseract.new("text.png")
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

puts temp
