class HomeController < ApplicationController
  def index
    @grooveshark = Rocola::Grooveshark.new
    @tinysong = Rocola::Tinysong::Search.new params[:search] || {}
    @tinysong.search
  end
end
