class UsersController < ApplicationController
    def index
      @users = User.all.order(created_at: :desc)
    end
  
    def show
      @user = User.includes(:address, :company,albums: :album_details).find(params[:id])
    end
  
    def new
      @user = User.new
      @user.build_address
      render partial: 'form'
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to root_path
      else
        render :new
      end
    end
  
    def edit
      @user = User.find(params[:id])
      render partial: 'form'
    end
  
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to @user
      else
        render :edit
      end
    end
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to root_path
    end
  
    def search
      if params[:search].blank?
        @users = User.all.order(created_at: :desc)
      else
        @users = User.where('username ILIKE ?', "%#{params[:search]}%")
      end
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("search_results", partial: "users/search_results", locals: { users: @users })
        end
        format.html { render partial: 'users/search_results', locals: { users: @users } }
      end
    end
  
    
    private
  
    def user_params
      params.require(:user).permit(:name, :username, :email, :phone, :website, :profile_pic, :company_id, address_attributes: [:id,:street, :suite, :city, :zipcode])
    end
  end
  