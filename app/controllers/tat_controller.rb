# coding: utf-8
class TatController < ApplicationController
  #skip_before_filter :verify_authenticity_token
  def index
    #Initialise les données liées à la session de l'utilisateur
    @note = Note.new
    if !session[:key].nil?
      @tat = Tat.find(session[:key])
    end
    if @tat.nil? or !params[:reset].nil?
     reset
    flash.discard(:success)

    end
    session[:splitter] = '|-@-|'
  end

  def create
    #Controle les données utilisateurs avant la céation du texte à trous
    if !session[:key].nil?
      @tat = Tat.find(session[:key])
    end
    if @tat.nil? or !params[:reset].nil?
      reset
      flash.discard(:success)
    end
    #Controle si le partage est activé ou non puis reroute vers index
    if @tat.step == "tat" or @tat.step == "answers"
      if params[:share] == "true"
        share
      else
        session[:share] = nil
      end
    end
    #Reroute vers les différentes méthodes en fonctions des données envoyées par l'utilisateur
    if params[:session] && !params[:session][:inputFile].nil? && @tat.step == "init"
      @tat.step = "file"
      @tat.save!
      upload
    elsif params[:session] && !params[:session]["1"].nil? && @tat.step == "tat" && params[:share] == "false"
      @tat.step = "answers"
      @tat.save!
      tatVerify
    elsif params[:session] && !params[:session][:inputText].nil? && params[:session][:inputText] != "" && @tat.step == "init"
      @tat.fullText = params[:session][:inputText]
      @tat.step = "file"
      @tat.save!
    elsif params[:session] && !params[:session][:inputText].nil? && params[:session][:inputText] != "" && @tat.step == "file"
      @tat.fullText = params[:session][:inputText]
      @tat.error_margin = params[:session][:errorMargin]
      @tat.hidden_text = params[:session][:hiddenText]
      @tat.step = "tat"
      @tat.save!
      tatGeneration
    elsif !params[:note].nil?
      note = Note.new(note: params[:note].to_i, commentaire: params[:commentaire], created_at: DateTime.now)
      note.save!
    flash[:success] = "1"
    elsif session[:share].nil?
    @tat.step = "init" 
    @tat.save!
    end
    redirect_to action: "index"
  end

  def upload
    #Méthode permettant à l'utilisateur de charger un fichier
    require 'core/IOFiles.rb'
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
    array_tat = TATNLP.generateTat(@tat.fullText, @tat.hidden_text)
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
      array_isRight = TATNLP.verifyAnswers(tat_answers, user_answers, @tat.error_margin)
      @tat.user_answers = user_answers.join(session[:splitter])
      @tat.is_right = array_isRight.join(session[:splitter])
    end
    @tat.save!
  end

  def share
    @tat_share = Tat_share.new
    @tat_share.fullText = @tat.fullText
    @tat_share.tat_content = @tat.tat_content
    @tat_share.tat_answers = @tat.tat_answers
    @tat_share.error_margin = @tat.error_margin
    @tat_share.hidden_text = @tat.hidden_text
    @tat_share.save!
    session[:share] = @tat_share.id
  end

  def show
    tat_share_id = Hash.new
    tat_share_id["$oid"] = params[:id]
    @tat_share = Tat_share.find(tat_share_id)
    if @tat_share.nil?
      session[:tat_share_found] = "false"
    elsif !params[:id].nil?
      #reset_session
      session[:tat_share_found] = "true"
      @tat = Tat.new
      @tat.fullText = @tat_share.fullText
      @tat.tat_content = @tat_share.tat_content
      @tat.tat_answers = @tat_share.tat_answers
      @tat.hidden_text = @tat_share.hidden_text
      @tat.error_margin = @tat_share.error_margin
      @tat.step = "tat"
      @tat.save!
      session[:key] = @tat.id
    end
    redirect_to action: "index"
  end

  def reset
    @tat = Tat.new
    @tat.step = "init"
    @tat.save!
    #reset_session
    session[:key] = @tat.id
    redirect_to action: "index"
  end
end
