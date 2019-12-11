class CreateOverviews < ActiveRecord::Migration[5.1]
  def change
    create_table :overviews do |t|

      t.datetime :last_overview, :null => false, :default => Time.now
    end
  end
end
