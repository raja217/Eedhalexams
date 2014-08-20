class Answer < ActiveRecord::Base
	belongs_to :questions, :class_name => 'Question', :foreign_key => 'id'
	belongs_to :student_additional_field
	belongs_to :user
end

