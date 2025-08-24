module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :set_company, only: [:show, :update, :destroy]
      before_action :authorize_admin!, only: [:create, :update, :destroy]

      # GET /api/v1/companies
      def index
        companies = Company.all
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

      # GET /api/v1/companies/:id
      def show
        render_success(@company)
      end

      # POST /api/v1/companies
      def create
        company = Company.new(company_params)
        if company.save
          render_success(company, :created)
        else
          render_error(company.errors.full_messages, :unprocessable_entity)
        end
      end

      # PUT /api/v1/companies/:id
      def update
        if @company.update(company_params)
          render_success(@company)
        else
          render_error(@company.errors.full_messages, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/companies/:id
      def destroy
        @company.destroy
        render_success({ message: "Company deleted successfully" })
      end

      private

      def set_company
        @company = Company.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_error("Company not found", :not_found)
      end

      def company_params
        params.require(:company).permit(:name)
      end

      def authorize_admin!
        unless @current_user&.role == "admin"
          render_error("Forbidden: admin role required", :forbidden)
        end
      end
    end
  end
end
