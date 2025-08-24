class ChangeStatusToEnumInTasks < ActiveRecord::Migration[7.1]
  def up
    # Se a coluna já existir como string, convertemos para integer
    add_column :tasks, :status_tmp, :integer, default: 0, null: false

    # Mapear valores existentes (caso já tenhas dados)
    Task.reset_column_information
    Task.find_each do |task|
      case task[:status]
      when "pending" then task.update_column(:status_tmp, 0)
      when "in_progress" then task.update_column(:status_tmp, 1)
      when "done" then task.update_column(:status_tmp, 2)
      end
    end

    remove_column :tasks, :status
    rename_column :tasks, :status_tmp, :status
  end

  def down
    add_column :tasks, :status_tmp, :string

    Task.reset_column_information
    Task.find_each do |task|
      case task[:status]
      when 0 then task.update_column(:status_tmp, "pending")
      when 1 then task.update_column(:status_tmp, "in_progress")
      when 2 then task.update_column(:status_tmp, "done")
      end
    end

    remove_column :tasks, :status
    rename_column :tasks, :status_tmp, :status
  end
end
