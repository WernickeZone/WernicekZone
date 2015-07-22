# coding: utf-8

class TatController < ApplicationController
  def index
    session[:splitter] = '|-@-|'
    if !session[:key].nil?
      @tat = Tat.find_by(id: session[:key])
    end
    if @tat.nil?
      @tat = Tat.new
    end
  end

  def create
    @tat = Tat.new
    @tat.fullText = params[:session][:inputText]
    @tat.save!
    session[:key] = @tat.id
    #session[:inputText] = params[:session][:inputText]
    session[:hiddenText] = params[:session][:hiddenText]
    session[:errorMargin] = params[:session][:errorMargin]
    if params[:session][:inputFile].nil?
    #  if session[:inputText] == ""
      if @tat.fullText == ""
        @tat.tat_content = nil
        @tat.tat_responses = nil
        @tat.save!
        redirect_to action: "index"
      else
        tatGeneration
      end
    else
      upload
    end
  end

  def upload
    require 'core/IOFiles.rb'
    uploaded_io = params[:session][:inputFile]
    #session[:inputText] = IOFiles.getFileContent(uploaded_io)
    if IOFiles.isTextValid?(File.extname(uploaded_io.original_filename).downcase)
      @tat.fullText = IOFiles.getFileContent(uploaded_io)
    elsif IOFiles.isImageValid?(File.extname(uploaded_io.original_filename.to_s).downcase)
      require 'core/OCR.rb'
      @tat.fullText = OCR.translate(uploaded_io)
    else
      @tat.fullText = "Erreur lors du chargement du fichier."
    end
    @tat.tat_content = nil
    @tat.tat_responses = nil
    @tat.save!
    redirect_to action: "index"
  end

  def tatGeneration
    require 'core/tatnlp.rb'
    #include TAT
    #session[:tat] = TAT.generateTat(session[:inputText],'50%','0');
    #session[:inputText] = TATNLP.generateTat(session[:inputText], session[:hiddenText],'0')
    array_tat = TATNLP.generateTat(@tat.fullText, session[:hiddenText],'0')
    if (!array_tat.nil?)
      @tat.tat_content = array_tat[0].join(session[:splitter])
      @tat.tat_responses = array_tat[1].join(session[:splitter])
      @tat.fullText = nil
      @tat.save!
    end
    redirect_to action: "index"
  end
end
