class HomeController < ApplicationController
  def index
  	if !current_user.nil?
  		redirect_to nodes_path
  	end
  end
end
