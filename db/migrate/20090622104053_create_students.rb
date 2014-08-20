class CreateStudents < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string     :admission_no

      t.string     :first_name
      t.string     :middle_name
      t.string     :last_name

      t.references :batch
      t.date       :date_of_birth
      t.string     :gender
      t.references :student_category

      t.string     :address_line1
      t.string     :address_line2
      t.string     :city
      t.string     :state
      t.string     :pin_code
      t.integer    :country_id

      t.string     :phone1
      t.string     :phone2
      t.string     :email

      t.string     :tenth
      t.string     :year
      t.string     :percent10

      t.string     :twleth
      t.string     :year12
      t.string     :percent12

      t.string     :college_name
      t.string     :degree
      t.string     :subject
      t.string     :yeard
      t.string     :overall

      t.text       :project_name
      t.text       :duration
      t.text       :project
      t.text       :technical

      t.references :immediate_contact
      t.boolean    :is_sms_enabled, :default=>true

      t.string     :photo_filename
      t.string     :photo_content_type
      t.binary     :photo_data, :limit => 5.megabytes

      t.string     :status_description
      t.boolean    :is_active, :default => true
      t.boolean    :is_deleted, :default => false


      t.timestamps
    end

    # Student categories

    create_table :student_categories do |t|
      t.string  :name
      t.boolean :is_deleted, :default=> false
    end
  end

  def self.down
    drop_table :student_categories
    drop_table :students
  end

end
