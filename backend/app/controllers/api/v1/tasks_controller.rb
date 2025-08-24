module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy, :complete]
      before_action :authorize_admin!, only: [:create, :update, :destroy]
      before_action :authorize_admin_or_owner!, only: [:show]

      # GET /api/v1/tasks
      def index
        tasks = Task.where(company_id: @current_user.company_id)
        tasks = tasks.where(status: params[:status]) if params[:status].present?

        pagy, records = pagy(tasks, items: (params[:per_page] || 10))

        render_success({
          tasks: records,
          pagination: {
            page: pagy.page,
            pages: pagy.pages,
            count: pagy.count,
            per_page: pagy.vars[:items]
          }
        })
      end

      # GET /api/v1/tasks/:id
      def show
        render_success(@task)
      end

      # POST /api/v1/tasks
      def create
        task = Task.new(task_params.merge(company_id: @current_user.company_id))

        if task.save
          render_success(task, :created)
        else
          render_error(task.errors.full_messages, :unprocessable_entity)
        end
      end

      # PUT /api/v1/tasks/:id
      def update
        if @task.update(task_params)
          render_success(@task)
        else
          render_error(@task.errors.full_messages, :unprocessable_entity)
        end
      end

      # DELETE /api/v1/tasks/:id
      def destroy
        @task.destroy
        render_success({ message: "Task deleted successfully" })
      end

      # PATCH /api/v1/tasks/:id/complete
      def complete
        if @current_user.role == "user"
          @task.update(status: :completed)
          render_success(@task)
        else
          render_error("Forbidden: only normal users can mark tasks as completed", :forbidden)
        end
      end

      private

      def set_task
        @task = Task.find(params[:id])
        if @task.company_id != @current_user.company_id
          render_error("Forbidden: task belongs to another company", :forbidden)
        end
      rescue ActiveRecord::RecordNotFound
        render_error("Task not found", :not_found)
      end

      def task_params
        params.require(:task).permit(:title, :description, :user_id, :status)
      end

      def authorize_admin!
        return if @current_user&.role == "admin"
        render_error("Forbidden: admin role required", :forbidden)
      end

      def authorize_admin_or_owner!
        return if @current_user&.role == "admin"
        return if @task.user_id == @current_user.id
        render_error("Forbidden: you can only view your own tasks", :forbidden)
      end
    end
  end
end
