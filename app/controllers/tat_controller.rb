# coding: utf-8

class TatController < ApplicationController
  def index
  end

  def create
    session[:inputText] = params[:session][:inputText]
    session[:hiddenText] = params[:session][:hiddenText]
    session[:errorMargin] = params[:session][:errorMagrin]
    if params[:session][:inputFile].nil?
      if session[:inputText] == ""
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
    session[:inputText] = IOFiles.getFileContent(uploaded_io)
    redirect_to action: "index"
  end

  def tatGeneration
    require 'core/tat.rb'
    #include TAT
    #session[:tat] = TAT.generateTat(session[:inputText],'50%','0');
    session[:inputText] = TAT.generateTat(session[:inputText], session[:hiddenText],'0');
    redirect_to action: "index"
  end
end
