class AddExtraToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :nationality_id, :integer
    add_column :students, :alt_email, :string
    add_column :students, :alt_mobile, :string
    add_column :students, :university, :string
    add_column :students, :univ_state, :string
    add_column :students, :dip, :string
    add_column :students, :percentdip, :string
    add_column :students, :yeardip, :string
    add_column :students, :grad_coll, :string
    add_column :students, :pg_coll, :string
    add_column :students, :pgd, :string
    add_column :students, :pgsub, :string
    add_column :students, :percentpg, :string
    add_column :students, :yearpg, :string
    add_column :students, :curaddlin1, :string
    add_column :students, :curraddlin2, :string
    add_column :students, :curcity, :string
    add_column :students, :curst, :string
  end

  def self.down
    remove_column :students, :curst
    remove_column :students, :curcity
    remove_column :students, :curraddlin2
    remove_column :students, :curaddlin1
    remove_column :students, :yearpg
    remove_column :students, :percentpg
    remove_column :students, :pgsub
    remove_column :students, :pgd
    remove_column :students, :pg_coll
    remove_column :students, :grad_coll
    remove_column :students, :yeardip
    remove_column :students, :percentdip
    remove_column :students, :dip
    remove_column :students, :univ_state
    remove_column :students, :university
    remove_column :students, :alt_mobile
    remove_column :students, :alt_email
    remove_column :students, :nationality_id
  end
end
