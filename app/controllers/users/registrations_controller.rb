class Users::RegistrationsController < Devise::RegistrationsController
	def append_or_create
	    @user = User.find_by email: sign_up_params[:email]
	    if @user.nil?
		    Authentication.create provider: "synapz", uid: self.resource.id
		    flash[:waiting_for_confirmation] = !self.resource.confirmed?
	  	  create
	    else
		    providers = @user.authentications.map{ |a| a.provider }
		    flash[:email_registered_already] = !providers.empty?
		    flash[:notice] = "This email is already in use. It has been registered via these accounts - "+@user.authentications.map{|a| a.provider=="google_oauth2"? "gmail" : a.provider }.join(", ")+". Please login using one of those"
		    redirect_to root_path
	    end
	end


end
