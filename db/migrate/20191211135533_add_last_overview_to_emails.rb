class AddLastOverviewToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :last_overview, :datetime, :null => false, :default => Time.now
  end
end
