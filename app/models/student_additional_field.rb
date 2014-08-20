class StudentAdditionalField < ActiveRecord::Base
  belongs_to :exam_group
  belongs_to :student_additional_detail
  has_many :questions
  validates_presence_of :name
  validates_uniqueness_of :name,:case_sensitive => false
  validates_format_of     :name, :with => /^[a-z ][a-z0-9 ]*$/i,
    :message => "#{t('must_contain_only_letters_numbers_space')}"
 
 def moduless
 	questions.map { |a| a.student_additional_field_id } 	
 end
end