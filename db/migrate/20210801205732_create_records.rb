class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :title
      t.string :years
      t.references :artist, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
