module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :destroy]

      # GET /tasks
      def index
        tasks = Task.all
        tasks = tasks.where(status: params[:status]) if params[:status].present?
        tasks = tasks.where(company_id: params[:company_id]) if params[:company_id].present?
        tasks = tasks.where(user_id: params[:user_id]) if params[:user_id].present?

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

      # GET /tasks/:id
      def show
        render_success(@task)
      end

      # POST /tasks
      def create
        task = Task.new(task_params)
        if task.save
          render_success(task, :created)
        else
          render_error(task.errors.full_messages)
        end
      end

      # PUT /tasks/:id
      def update
        if @task.update(task_params)
          render_success(@task)
        else
          render_error(@task.errors.full_messages)
        end
      end

      # DELETE /tasks/:id
      def destroy
        @task.destroy
        render_success({ message: "Task deleted successfully" })
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(:title, :status, :user_id, :company_id)
      end
    end
  end
end