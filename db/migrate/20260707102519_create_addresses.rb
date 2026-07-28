class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :street_address, null: false
      t.string :suburb, null: false
      t.string :state, null: false, default: "NSW"
      t.string :postcode, null: false
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.text :notes

      t.timestamps
    end
    add_index :addresses, [:suburb, :postcode]
  end
end
