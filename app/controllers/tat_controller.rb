# coding: utf-8
class TatController < ApplicationController
  def index
    #Initialise les données liées à la session de l'utilisateur
    session[:splitter] = '|-@-|'
    if !session[:key].nil?
      @tat = Tat.find(session[:key])
    end
    if @tat.nil?
      @tat = Tat.new
      @tat.step = "init"
      @tat.save!
      session[:key] = @tat.id
    end
  end

  def create
    #Controle les données utilisateurs avant la céation du texte à trous
    if !session[:key].nil?
      @tat = Tat.find(session[:key])
    end
    if @tat.nil?
      @tat = Tat.new
      @tat.step = "init"
      @tat.save!
      session[:key] = @tat.id
    end
    # Obligée d'ajouter "if params[:session]" >> sinon erreur
    session[:hiddenText] = params[:session][:hiddenText] if params[:session]
    session[:errorMargin] = params[:session][:errorMargin] if params[:session]
    #Reroute vers les différentes méthodes en fonctions des données envoyées par l'utilisateur
    if params[:session] && !params[:session][:inputFile].nil?
      @tat.step = "file"
      @tat.save!
      upload
    elsif params[:session] && !params[:session]["1"].nil? && @tat.step == "tat"
      @tat.step = "answers"
      @tat.save!
      tatVerify
    elsif params[:session] && !params[:session][:inputText].nil? && params[:session][:inputText] != "" && @tat.step == "init"
      @tat.fullText = params[:session][:inputText]
      @tat.step = "file"
      @tat.save!
    elsif params[:session] && !params[:session][:inputText].nil? && params[:session][:inputText] != "" && @tat.step == "file"
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
    #Méthode permettant à l'utilisateur de charger un fichier
    require 'core/IOFiles.rb'
    session[:hiddenText] = params[:session][:hiddenText]
    session[:errorMargin] = params[:session][:errorMargin]
    uploaded_io = params[:session][:inputFile]
    #session[:inputText] = IOFiles.getFileContent(uploaded_io)
    #Si c'est un fichier texte, utilise l'extracteur de texte et si c'est un fichier image, l'OCR
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
    #Générer le texte à trous et l'envoie le stocke dans un object temporaire disponible pour le front-end
    require 'core/tatnlp.rb'
    array_tat = TATNLP.generateTat(@tat.fullText, session[:hiddenText])
    if (!array_tat.nil?)
      @tat.tat_content = array_tat[0].join(session[:splitter])
      @tat.tat_answers = array_tat[1].join(session[:splitter])
    else
      @tat.step = "init"
    end
    @tat.save!
  end

  def tatVerify
    #Vérifie les réponses du texte à trous et stocke la correction dans un objet temporaire pour le front-end
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
      array_isRight = TATNLP.verifyAnswers(tat_answers, user_answers, session[:errorMargin])
      @tat.user_answers = user_answers.join(session[:splitter])
      @tat.is_right = array_isRight.join(session[:splitter])
    end
    @tat.save!
  end
end
