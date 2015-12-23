class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :set_user
	before_action :set_team
	before_action :set_subdomain

	def set_user
		@user = current_user if current_user
	end

	def after_sign_in_path_for(resource)
		# current_user.teams.count > 1 ? choose_team_path	: redirect_team_choice
		log_pushup_path
	end

	def set_team
		@team = Team.find_by(subdomain: @subdomain)
	end

	def set_subdomain
		@subdomain = request.subdomain.downcase.gsub!("www.", '')
		puts @subdomain
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u|
			u.permit(:email, :name, :password, :password_confirmation, team_attributes: [:subdomain])
		}
	end

	def redirect_team_choice
		subdomain = current_user.teams.first.subdomain
	end

end
