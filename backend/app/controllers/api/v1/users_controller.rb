module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      skip_before_action :authorize_request, only: [:create, :index] # index só para debug
      
      # GET /users
      def index
        users = User.all
        users = users.where(role: params[:role]) if params[:role].present?
        users = users.where(company_id: params[:company_id]) if params[:company_id].present?

        pagy, records = pagy(users, items: (params[:per_page] || 10))

        render_success({
          users: records,
          pagination: {
            page: pagy.page,
            pages: pagy.pages,
            count: pagy.count,
            per_page: pagy.vars[:items]
          }
        })
      end

      # GET /users/:id
      def show
        render_success(@user)
      end

      # POST /users
      def create
        user = User.new(user_params)
        if user.save
          render_success(user, :created)
        else
          render_error(user.errors.full_messages)
        end
      end

      # PUT /users/:id
      def update
        if @user.update(user_params)
          render_success(@user)
        else
          render_error(@user.errors.full_messages)
        end
      end

      # DELETE /users/:id
      def destroy
        @user.destroy
        render_success({ message: "User deleted successfully" })
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :role, :company_id)
      end
    end
  end
end