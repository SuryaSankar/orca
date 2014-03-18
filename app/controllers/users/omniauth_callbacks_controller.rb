class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
	  auth = request.env['omniauth.auth']
	  handler auth[:provider],auth[:uid],auth[:info][:email] do |user|
		  user = User.new email: auth[:info][:email], password: SecureRandom.hex(10), uname: auth[:info][:name]
	  end
  end

  def google_oauth2
	  auth = request.env['omniauth.auth']
	  handler auth[:provider],auth[:uid],auth[:info][:email] do |user|
		  user = User.new email: auth[:info][:email], password: SecureRandom.hex(10), uname: auth[:info][:name]
	  end
  end

private

  def handler(provider, uid,  email)
    authentication = Authentication.find_by_provider_and_uid(provider, uid)
    
    if !user_signed_in?
	    if authentication
		    flash[:notice] = 'Signed in successfully' 
		    sign_in_and_redirect(:user, authentication.user)
	    else
		    if email != ''
			    user = User.find_by_email(email)
			    if user
				    user.authentications.create provider: provider, uid: uid
				    set_flash_message(:notice, :success, :kind => "the provider") if is_navigational_format?
				    sign_in_and_redirect user, event: :authentication #this will throw if @user is not activated
			    else
				    user = yield user
				    user.authentications.build provider: provider, uid: uid
				    user.skip_confirmation!
				    user.save
				    user.confirm!
				    flash[:notice]="You have successfully logged in"
				    sign_in_and_redirect(:user, user)
			    end
		    else
			    flash[:error] = provider + " cannot be used as no valid email address has been returned "
			    redirect_to new_user_session_path
		    end		
	    end
    else
	    flash[:error] = " You are already logged in "
	    redirect_to after_sign_in_path_for(current_user)
    end
  end

end
