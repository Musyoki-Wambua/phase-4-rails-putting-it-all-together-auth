class SessionsController < ApplicationController

    before_action :authorize, only: :destroy

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

    def create 
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
            session[:user_id]= user.id
            render json: user, status: :created
        else 
            render json: { errors: ["Invalid username of password"] }, status: :unauthorized
        end
    end

    def destroy
        user = User.find_by(id: session[:user_id])
        if user 
        session.delete :user_id
        else 
            render json: {errors: ["No user"]}, status: :unauthorized
        end
    end

    private 

    def authorize 
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end


    def render_not_found_response 
        render json: { error: "User not found" }, status: :unauthorized
    end


end
