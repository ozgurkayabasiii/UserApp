class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :suite
      t.string :city
      t.string :zipcode
      t.string :lat
      t.string :lng
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
