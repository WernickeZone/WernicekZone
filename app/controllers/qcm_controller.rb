# coding: utf-8
class QcmController < ApplicationController
  def index
    #Initialise les données liées à la session de l'utilisateur
    session[:splitter] = '|-@-|'
    if !session[:key].nil?
      @qcm = Qcm.find(id: session[:key])
    end
    if @qcm.nil?
      @qcm = Qcm.new
      @qcm.step = "init"
      @qcm.save!
      session[:key] = @qcm.id
    end
    ###
    respond_to do |format|
     format.html #responds with default html file
     format.js #this will be the javascript file we respond with
    end
    ###
  end

  def create
    #Controle les données utilisateurs avant la céation du texte à trous
    if !session[:key].nil?
      @qcm = Qcm.find(id: session[:key])
    end
    if @qcm.nil?
      @qcm = Qcm.new
      @qcm.step = "init"
      @qcm.save!
      session[:key] = @qcm.id
    end
    session[:hiddenText] = params[:session][:hiddenText]
    #Reroute vers les différentes méthodes en fonctions des données envoyées par l'utilisateur
    if !params[:session][:inputFile].nil?
      @qcm.step = "file"
      @qcm.save!
      upload
    elsif !params[:session]["1"].nil? && @qcm.step == "qcm"
      @qcm.step = "answers"
      @qcm.save!
      qcmVerify
    elsif !params[:session][:inputText].nil? && params[:session][:inputText] != ""
      @qcm.fullText = params[:session][:inputText]
      @qcm.step = "qcm"
      @qcm.save!
      qcmGeneration
    else
      @qcm.step = "init"
      @qcm.save!
    end
    redirect_to action: "index"
  end

  def upload
    #Méthode permettant à l'utilisateur de charger un fichier
    require 'core/IOFiles.rb'
    session[:hiddenText] = params[:session][:hiddenText]
    uploaded_io = params[:session][:inputFile]
    #session[:inputText] = IOFiles.getFileContent(uploaded_io)
    #Si c'est un fichier texte, utilise l'extracteur de texte et si c'est un fichier image, l'OCR
    if IOFiles.isTextValid?(File.extname(uploaded_io.original_filename).downcase)
      @qcm.fullText = IOFiles.getFileContent(uploaded_io)
    elsif IOFiles.isImageValid?(File.extname(uploaded_io.original_filename.to_s).downcase)
      require 'core/OCR.rb'
      @qcm.fullText = OCR.translate(uploaded_io)
    else
      @qcm.fullText = "Erreur lors du chargement du fichier."
    end
    @qcm.save!
  end

  def qcmGeneration
    #Générer le texte à trous et l'envoie le stocke dans un object temporaire disponible pour le front-end
    require 'core/qcmnlp.rb'
    array_qcm = QCMNlp.generateQcm(@qcm.fullText, session[:hiddenText])
    @qcm.qcm_answers = array_qcm[1];
    if (!array_qcm.nil?)
      array_qcm_choices = Array.new
      array_qcm[1].each do |q|
        array_qcm_choices.push q
        array_qcm_choices.push QCMNlp.generateAnswers(q)
      end
      @qcm.qcm_content = array_qcm[0].join(session[:splitter])
      @qcm.qcm_choices = array_qcm_choices[1].join(session[:splitter])
    else
      @qcm.step = "init"
    end
    @qcm.save!
  end

  def qcmVerify
    #Vérifie les réponses du texte à trous et stocke la correction dans un objet temporaire pour le front-end
    if (@qcm.qcm_answers.nil?)
      @qcm.step = "answers is null"
    else
      qcm_answers = @qcm.qcm_answers.split (session[:splitter])
      user_answers = Array.new
      array_isRight = Array.new
      j = qcm_answers.count;
      for i in 1..j
	user_answers.push params[:session][i.to_s]
        if user_answers[i - 1] == qcm_answers[i - 1]
          array_isRight.push "true"
        else
          array_isRight.push "false"
        end
      end
      @qcm.user_answers = user_answers.join(session[:splitter])
      @qcm.is_right = array_isRight.join(session[:splitter])
    end
    @qcm.save!
  end
end
