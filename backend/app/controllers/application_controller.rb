require "pagy"

class ApplicationController < ActionController::API
  include Pagy::Backend

  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActionController::ParameterMissing, with: :handle_missing_param

  private

  # --- Standardized responses ---

  def render_success(data, status = :ok)
    render json: { success: true, data: data, errors: nil }, status: status
  end

  def render_error(errors, status = :unprocessable_entity)
    render json: { success: false, data: nil, errors: Array(errors) }, status: status
  end

  # --- Error handling ---

  def handle_not_found(error)
    render_error(error.message, :not_found)
  end

  def handle_invalid_record(error)
    render_error(error.record.errors.full_messages, :unprocessable_entity)
  end

  def handle_missing_param(error)
    render_error(error.message, :bad_request)
  end

  # --- Auth ---

  def authorize_request
    header = request.headers['Authorization']&.split(' ')&.last
    return render(json: { error: 'Missing token' }, status: :unauthorized) unless header

    decoded = JsonWebToken.decode(header)
    return render(json: { error: 'Unauthorized' }, status: :unauthorized) unless decoded

    @current_user = User.find_by(id: decoded[:user_id])
    return render(json: { error: 'User not found' }, status: :unauthorized) unless @current_user
  end

  # --- Role helpers ---

  def authorize_admin!
    return if @current_user&.role == "admin"
    render_error("Forbidden: only admins can perform this action", :forbidden) and return
  end

  def authorize_admin_or_self!(user_id)
    return if @current_user&.role == "admin"
    return if @current_user&.id == user_id
    render_error("Forbidden: you can only manage your own account", :forbidden) and return
  end
end
