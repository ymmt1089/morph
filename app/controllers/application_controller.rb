class ApplicationController < ActionController::Base

	before_action :configure_permitted_parameters, if: :devise_controller?

	def after_sign_in_path_for(resource)#サインイン後に遷移するpathを設定（adminとuserで変更）
		if  admin_signed_in?
			admins_path
		else
			books_path
		end
	end

	def after_sign_out_path_for(resource)
    	books_path # ログアウト後に遷移するpathを設定
	end


	protected
		def configure_permitted_parameters
				devise_parameter_sanitizer.permit(:sign_up,keys:[:email,
		                                               			:encrypted_password,
																:user_name,
																:self_introduction,
																:user_image,
																:eset_password_token,
																:reset_password_sent_at,
																:remember_created_at,
																:created_at,
																:updated_at])
				devise_parameter_sanitizer.permit(:sign_in,keys:[:email,
	                                                   			:encrypted_password])
				devise_parameter_sanitizer.permit(:account_update, keys: [:name])
	end
end

