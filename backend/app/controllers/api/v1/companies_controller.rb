module Api
  module V1
    class CompaniesController < ApplicationController
      before_action :set_company, only: [:show, :update, :destroy]

      # GET /companies
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

      # GET /companies/:id
      def show
        render_success(@company)
      end

      # POST /companies
      def create
        company = Company.new(company_params)
        if company.save
          render_success(company, :created)
        else
          render_error(company.errors.full_messages)
        end
      end

      # PUT /companies/:id
      def update
        if @company.update(company_params)
          render_success(@company)
        else
          render_error(@company.errors.full_messages)
        end
      end

      # DELETE /companies/:id
      def destroy
        @company.destroy
        render_success({ message: "Company deleted successfully" })
      end

      private

      def set_company
        @company = Company.find(params[:id])
      end

      def company_params
        params.require(:company).permit(:name)
      end
    end
  end
end