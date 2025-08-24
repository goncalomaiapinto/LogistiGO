module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]
      before_action :authorize_admin!, only: [:index, :create, :destroy]
      before_action :authorize_admin_or_self!, only: [:show, :update]
      before_action :normalize_email, only: [:create, :update]

      # GET /api/v1/users
      def index
        companies = Company.all
        companies = companies.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?

        pagy, records = pagy(companies, items: (params[:per_page] || 10))

        render_success({
          companies: records,
          pagination: {
            page: pagy.page,
            pages: pagy.pages,
            count: pagy.count,
            per_page: pagy.vars[:items]
          }
        })
      end

      # GET /api/v1/users/:id
      def show
        render_success(@user)
      end

      # POST /api/v1/users
      def create
        user = User.new(user_params)
        if user.save
          render_success(user, :created)
        else
          render_error(user.errors.full_messages, :unprocessable_entity)
        end
      end

      # PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render_success(@user)
        else
          render_error(@user.errors.full_messages, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        render_success({ message: "User deleted successfully" })
      end

      private

      def set_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_error("User not found", :not_found)
      end

      def user_params
        allowed = params.require(:user).permit(:name, :email, :password, :role, :company_id)
        if @current_user&.role != "admin"
          allowed[:role] = "user"
        else
          allowed[:role] = %w[admin user].include?(allowed[:role]) ? allowed[:role] : "user"
        end
        allowed
      end

      def normalize_email
        params[:user][:email]&.downcase!
      end

      def authorize_admin!
        return if @current_user&.role == "admin"
        render_error("Forbidden: only admins can perform this action", :forbidden)
      end

      def authorize_admin_or_self!
        return if @current_user&.role == "admin"
        return if @user.id == @current_user&.id
        render_error("Forbidden: you can only manage your own account", :forbidden)
      end
    end
  end
end
