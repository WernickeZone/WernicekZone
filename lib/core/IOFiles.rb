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
end
