require "pagy"

class ApplicationController < ActionController::API
  include Pagy::Backend

  before_action :authorize_request

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActionController::ParameterMissing, with: :handle_missing_param

  private

  def render_success(data, status = :ok)
    render json: { success: true, data: data, errors: nil }, status: status
  end

  def render_error(errors, status = :unprocessable_entity)
    render json: { success: false, data: nil, errors: Array(errors) }, status: status
  end

  # --- Tratamento global de erros ---

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
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JsonWebToken.decode(header)

    if decoded
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

end
