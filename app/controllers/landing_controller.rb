class LandingController < ApplicationController
  def index
  end

  def create
    if !params[:newsletter].nil?
      if Newsletter.find_by(email: params[:newsletter][:email].downcase).nil?
        @newsletter = Newsletter.new
        @newsletter.email = params[:newsletter][:email].downcase
        @newsletter.save!
      end
    elsif !params[:contacts].nil?
      @contact = Contact.new
      @contact.nom = params[:contact][:nom]
      @contact.email = params[:contact][:email].downcase
      @contact.message params[:contact][:message]
      @contact.save!
    end
    redirect_to :action => :index
  end
end
