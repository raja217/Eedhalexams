class QuestionsController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def index
   @batch = Batch.find(params[:batch_id])
   @exam_group = ExamGroup.find(params[:exam_group_id])
   @module = StudentAdditionalField.find(params[:module_id])
   @questions = Question.find(:all, :conditions=>['exam_group_id=? && student_additional_field_id=?', @exam_group, @module ], :order => 'student_additional_field_id asc')
  end
  def new
    @question = Question.new
    @batch = Batch.find(params[:batch_id])
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @module = StudentAdditionalField.find(params[:module_id]) 
    @ques = Question.last 
    @questions = Question.find(:all, :conditions => ['exam_group_id=? && student_additional_field_id=?',@exam_group,@module])
    @mod = @module.total.to_i - @questions.count.to_i 
  end
  def edit
    @quest = Question.find(params[:id])
    @question = Question.find(params[:id])  
    @batch = Batch.find(params[:batch_id])
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @question.is_answer = params[:is_answer]
    @question.is_pass = params[:is_pass].to_s
    @fin = Question.find_by_id(@question)
    @module = StudentAdditionalField.find(params[:module_id])
    if request.post? and @question.update_attributes(params[:question])
      flash[:notice] = "Edited sucessfully"
      redirect_to batch_exam_group_module_questions_path(@batch,@exam_group,@module)
    end
  end
  def update
    @question = Question.find(params[:id])  
    @batch = Batch.find(params[:batch_id])
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @module = StudentAdditionalField.find(params[:module_id])
    @question.is_pass = params[:is_pass].to_s
    @question.is_answer = params[:is_answer].to_s
    if @question.update_attributes(params[:question])
      flash[:notice] = "Edited sucessfully"
      redirect_to batch_exam_group_module_questions_path(@batch,@exam_group,@module)
    end
  end
  def destroy
    @question = Question.find(params[:id]).destroy
    flash[:notice] = "Question deleted"
    redirect_to batch_exam_group_module_questions_path(@batch,@exam_group,@module)
  end
  def _ques
    @question = Question.new
    @batch = Batch.find(params[:batch_id])
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @module = StudentAdditionalField.find(params[:module_id])
  end

  def create
    @batch = Batch.find(params[:batch_id])
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @module = StudentAdditionalField.find_by_id(params[:module_id])
    @question = Question.new(params[:question])
    @question.is_answer = params[:is_answer]  
    @question.student_additional_field_id = @module.id
    @question.exam_group_id = @exam_group.id
    @question.is_pass = params[:is_pass].to_s
    if request.post? and @question.save
      @mod = StudentAdditionalField.find_by_sql ["SELECT total FROM student_additional_fields WHERE id=?" ,@module]
      total = @mod[0].total
      @m = Question.find_by_sql ["SELECT COUNT(*) FROM questions where student_additional_field_id=?",@module]
      redirect_to new_batch_exam_group_module_question_path(@batch,@exam_group,@module)
    end
  end 
end
