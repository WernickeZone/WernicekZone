# coding: utf-8

class TatController < ApplicationController
  def index
    session[:splitter] = '|-@-|'
    if !session[:key].nil?
      @tat = Tat.find_by(id: session[:key])
    end
    if @tat.nil?
      @tat = Tat.new
      @tat.step = "init"
	  @tat.save!
	  session[:key] = @tat.id
    end
  end

  def create
    if !session[:key].nil?
      @tat = Tat.find_by(id: session[:key])
    end
    if @tat.nil?
      @tat = Tat.new
	  @tat.step = "init"
      @tat.save!
      session[:key] = @tat.id
	end
    session[:hiddenText] = params[:session][:hiddenText]
    session[:errorMargin] = params[:session][:errorMargin]
    if !params[:session][:inputFile].nil?
	  @tat.step = "file"
      @tat.save!
      upload
    elsif !params[:session]["1"].nil? && @tat.step == "tat"
      @tat.step = "answers"
      @tat.save!
      tatVerify
    elsif !params[:session][:inputText].nil? && params[:session][:inputText] != ""
	  @tat.fullText = params[:session][:inputText]
	  @tat.step = "tat"
      @tat.save!
      tatGeneration
	else
      @tat.step = "init"
      @tat.save!
    end
	redirect_to action: "index"
  end

  def upload
    require 'core/IOFiles.rb'
    session[:hiddenText] = params[:session][:hiddenText]
    session[:errorMargin] = params[:session][:errorMargin]
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
    @tat.save!
  end

  def tatGeneration
    require 'core/tatnlp.rb'
    array_tat = TATNLP.generateTat(@tat.fullText, session[:hiddenText],'0')
    if (!array_tat.nil?)
      @tat.tat_content = array_tat[0].join(session[:splitter])
      @tat.tat_answers = array_tat[1].join(session[:splitter])
	else
      @tat.step = "init"
    end
	@tat.save!
  end

  def tatVerify
    require 'core/tatnlp.rb'
	if (@tat.tat_answers.nil?)
		@tat.step = "answers is null"
	else
		tat_answers = @tat.tat_answers.split (session[:splitter])
		user_answers = Array.new
		j = tat_answers.count
		for i in 1..j
			user_answers.push params[:session][i.to_s]
		end
		array_isRight = TATNLP.verifyAnswers(tat_answers, user_answers)
		@tat.user_answers = user_answers.join(session[:splitter])
		@tat.is_right = array_isRight.join(session[:splitter])
	end
	@tat.save!
  end
end
