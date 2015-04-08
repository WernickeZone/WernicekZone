# coding: utf-8

class TatController < ApplicationController
  def index
  end

  def create
    session[:inputText] = params[:session][:inputText]
    if params[:session][:inputFile].nil?
      redirect_to action: "index"
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
end
