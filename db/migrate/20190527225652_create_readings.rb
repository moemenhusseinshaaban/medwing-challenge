class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.bigint      :number
      t.float       :temperature
      t.float       :humidity
      t.float       :battery_charge
      t.references  :thermostat, index: true
    end
    add_index :readings, [:thermostat_id, :number], unique: true
  end
end
