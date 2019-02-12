class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.string :title
      t.string :description
      t.string :url
      t.boolean :read
      t.references :email, foreign_key: true

      t.timestamps
    end
  end
end
