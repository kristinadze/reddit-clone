class UsersController < ApplicationController
    before_action :require_signed_in!, only: [:show]
    before_action :require_signed_out!, only: [:new, :create]
    before_action :index
    
    def index 
        @q = Sub.ransack(params[:q])
        @subs = @q.result
    end
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            sign_in(@user)
            redirect_to subs_url
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end
end