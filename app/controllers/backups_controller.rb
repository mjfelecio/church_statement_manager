class BackupsController < ApplicationController
  def new
  end

  def create
    file = params[:backup_file]
    unless file
      redirect_to new_backup_path, alert: "Please select a backup file."
      return
    end

    content = file.read
    BackupService.validate(content)
    store_backup_for_restore(content)

    redirect_to backup_path, notice: "Backup validated successfully."
  rescue BackupService::ImportError, JSON::ParserError => e
    redirect_to new_backup_path, alert: e.message
  end

  def show
    content = retrieve_backup_for_restore
    unless content
      redirect_to new_backup_path, alert: "No backup data found. Please upload a backup file."
      return
    end
    @backup_data = JSON.parse(content)
  end

  def confirm
    content = retrieve_backup_for_restore
    unless content
      redirect_to new_backup_path, alert: "No backup data found. Please upload a backup file again."
      return
    end

    BackupService.import(content)
    clear_stored_backup!
    redirect_to root_path, notice: "Backup restored successfully."
  rescue BackupService::ImportError => e
    clear_stored_backup!
    redirect_to new_backup_path, alert: "Restore failed: #{e.message}"
  end

  def download
    json = BackupService.export
    send_data json,
      filename: "church-statement-backup-#{Date.current.iso8601}.json",
      type: "application/json"
  end

  def reset
    only_statements = params[:only_statements] == "true"
    BackupService.reset!(only_statements: only_statements)

    notice = if only_statements
      "Statements and transactions have been reset."
    else
      "All data has been reset."
    end

    redirect_to root_path, notice: notice
  end

  private

  def store_backup_for_restore(content)
    token = SecureRandom.hex(32)
    temp_dir = Rails.root.join("tmp", "backups")
    FileUtils.mkdir_p(temp_dir)
    File.write(temp_dir.join("#{token}.json"), content)
    session[:backup_token] = token
  end

  def retrieve_backup_for_restore
    token = session[:backup_token]
    return nil unless token
    path = Rails.root.join("tmp", "backups", "#{token}.json")
    return nil unless File.exist?(path)
    File.read(path)
  end

  def clear_stored_backup!
    token = session.delete(:backup_token)
    return unless token
    path = Rails.root.join("tmp", "backups", "#{token}.json")
    File.delete(path) if File.exist?(path)
  end
end
