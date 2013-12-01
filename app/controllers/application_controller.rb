class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :reload_libs if Rails.env.development?
  private
    def reload_libs
      Dir["#{Rails.root}/lib/**/*.rb"].each { |path| require_dependency path }
    end
end
