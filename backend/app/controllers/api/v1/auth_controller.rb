module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorize_request, only: [:login, :register]

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email].to_s.downcase)

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id, role: user.role, exp: 24.hours.from_now.to_i)
          render_success({
            token: token,
            exp: 24.hours.from_now.strftime("%Y-%m-%d %H:%M"),
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          })
        else
          render_error("Invalid email or password", :unauthorized)
        end
      end

      # POST /api/v1/auth/register
      def register
        user = User.new(user_params)
        user.email = user.email.downcase
        user.role = %w[admin user].include?(user.role) ? user.role : "user"

        if user.save
          token = JsonWebToken.encode(user_id: user.id, role: user.role, exp: 24.hours.from_now.to_i)
          render_success({
            message: "User created successfully",
            token: token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          }, :created)
        else
          render_error(user.errors.full_messages)
        end
      end

      # POST /api/v1/auth/logout
      def logout
        render_success({ message: "Logout successful. Please discard token on client." })
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :role, :company_id)
      end
    end
  end
end
