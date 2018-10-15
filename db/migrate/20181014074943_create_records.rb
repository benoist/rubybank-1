class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.decimal :amount
      t.string :status
      t.string :reference
      t.string :note
      t.references :counterpart, index: true

      t.references :bank_account, foreign_key: true
      t.timestamps
    end
  end
end
