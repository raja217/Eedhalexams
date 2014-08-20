class Question < ActiveRecord::Base
	xss_terminate :except => [:ques, :ans1, :ans2, :ans3, :ans4]
	validates_presence_of :ans1, :ans2, :ans3, :ans4, :ques, :is_answer
  belongs_to :student_additional_fields, :class_name => 'StudentAdditionalfield', :foreign_key => 'id'
  belongs_to :exam_groups, :class_name => 'ExamGroup', :foreign_key => 'id' 
  

  	
end
