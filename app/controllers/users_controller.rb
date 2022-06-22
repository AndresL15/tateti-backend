class UsersController < ApplicationController

    def create
        @user = User.create(params_user)
        if @user.persisted?
            render status: 200, json: { token: @user.token }
        else
            render status: 404, json: { message: "No se pudo crear el user: #{ @user.errors.details }"}
        end
    end

    def login
        @user = User.find_by(name: params[:name])
        if @user.blank? || @user.password != params[:password]
            render status: 404, json: { message: "Datos incorrectos"}
        elsif 
            render status: 200, json: { token: @user.token }
        end
    end

    def current
        @user = User.find_by(token: params[:token])
        if @user.blank?
            render status: 404, json: { message: "No se encontro ese user"}
        else
            render status: 200, json: { name: @user.name }
        end
    end

    def logout
        @user = User.find_by(token: params[:token])
        if @user.blank?
            render status: 200, json: { message: "Logout correcto"}
        else
            render status: 404, json: { message: "No se encontro ese user"}
        end
    end

    private
        
        def params_user
            params.require(:user).permit(:name, :password)
        end

end



