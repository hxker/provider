class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

# GET /resource/sign_in
#   def new
#    super
#   end

# POST /resource/sign_in
#   def create
#     super
# end

# DELETE /resource/sign_out
  def destroy
    # super
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    respond_to do |format|
      format.all { head :no_content }
      if params[:return_url].present?
        format.any(*navigational_formats) { redirect_to params[:return_url] }
      else
        format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
      end
    end
  end

# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_in_params
#   devise_parameter_sanitizer.for(:sign_in) << :attribute
# end
end
