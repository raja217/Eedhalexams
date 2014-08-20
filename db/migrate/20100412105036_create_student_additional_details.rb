class CreateStudentAdditionalDetails < ActiveRecord::Migration
  def self.up
    create_table :student_additional_details do |t|
      t.references :student
      t.references :modules
      t.references :questions
      t.string     :additional_info
      t.references :additional_field
    end
  end

  def self.down
    drop_table :student_additional_details
  end
end