# coding: utf-8
module IOFiles
  require 'yomu'
  def IOFiles.getLocalFileContent(name)
	doc = File.read name
	text = Yomu.read :text, doc
  end
  def IOFiles.getFileContent(file)
    data = file.read
    text = Yomu.read :text, data
  end
  def IOFiles.getFileType(file)
    return File.extname(file)
  end
  def IOFiles.isImageValid?(file)
    images = [ :png, :jpg, :jpeg ]
    #Liste incomplète
    images.each do | ext |
      if IOFiles.getFileType(file) == ('.' + ext.to_s)
        return true
      end
    end
    return false
  end
  def IOFiles.isTextValid?(file)
    texts = [:doc, :docx, :xls, :xlsx, :ppt, :pptx,
             :odt, :ods, :odp, :rtf, :pdf, :txt]
    #Liste incomplète
    texts.each do | ext |
      if IOFiles.getFileType(file) == ('.' + ext.to_s)
        return true
      end
    end
    return false
  end
end

include IOFiles
file = File.new('machin.docx')
content = IOFiles.getFileType(file)
bool = IOFiles.isImageValid?(file)
puts bool
bool = IOFiles.isTextValid?(file)
puts bool
