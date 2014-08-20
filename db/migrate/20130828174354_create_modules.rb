class CreateModules < ActiveRecord::Migration
  def self.up
    create_table :modules do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :modules
  end
end
