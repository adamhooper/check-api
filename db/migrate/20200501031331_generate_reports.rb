class GenerateReports < ActiveRecord::Migration
  def change
    Rails.cache.write('check:migrate:generate_reports:last_id', Dynamic.last&.id || 0)
  end
end
