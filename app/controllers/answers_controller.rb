class AnswersController < ApplicationController
	before_filter :login_required
  
	filter_access_to :all

	def index
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @batch =@student.batch_id
    @exam = ExamGroup.find(:all, :conditions => ['exam_date <= ? && batch_id =?' , Date.today, @batch])
    session[:xam] = []
    @exam.each do |e|
      session[:xam].push e
    end
    @exams = session[:xam].first
	end
	def update_exam
		@exams = ExamGroup.find(params[:exam_group])
		render(:update) do |page|
      page.replace_html 'update_exam', :partial=>'update_exam'
    end
  end
  def exam
    @exam_group = ExamGroup.find(params[:exam_group_id])
    mod = @exam_group.modules.split(',')
    @modules = StudentAdditionalField.find(:all, :conditions => ['id in (?)',mod])
    
 	end
  def answer 
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @answer = Answer.new
    mod = @exam_group.modules.split(',')
    @modules = StudentAdditionalField.find(:all, :conditions => ['id in (?)',mod])
    session[:mod] = []
    @modules.each do |m|
      session[:mod].push m
    end
    @module = session[:mod].first
    @questions = Question.find(:all, :conditions => ['exam_group_id=? && student_additional_field_id=?',@exam_group,@module])
    @fin = Answer.find_by_id(1, :conditions => ['user_id=?',@user])
  end

  def start
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find_by_id(params[:exam_group_id])
    @answer = Answer.new(params[:ans])
    @module = params[:student_additional_field]
    @ques = Question.find(:all, :conditions => ['exam_group_id=? && student_additional_field_id=?',@exam_group,@module])
    mcq = []
    comp = []
    @ques.each do |q|
      if q.is_pass == 'comp'
        comp.push q.id unless q.id.nil?
      else
        mcq.push q.id unless q.id.nil?
      end
    end
    @questions = mcq.shuffle.concat(comp)
    session[:ques] = @questions
    a = session[:ques].first
    @slno = 1
    @fin = Answer.find_by_questions_id(a, :conditions => ['user_id=?',@user])
    @ans = Question.find_by_id(a)  
    unless @fin.nil?
        if (@fin.visited == 1)
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ren', :object => @ans
            page.replace_html 'quespan', :partial => 'ques', :object => @fin
          end
        else
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans', :object => @ans
            page.replace_html 'quespan', :partial => 'ques', :object => @fin
          end
        end
    else
      render(:update) do |page|
        page.replace_html 'main', :partial => 'ans', :object => @ans
        page.replace_html 'quespan', :partial => 'ques', :object => @fin
      end
    end
  end
  def next_mod
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find_by_id(params[:exam_group_id])
    m = params[:module_id].to_i
    @modules = session[:mod]
    @module = @modules[m]
    @questions = Question.find(:all, :conditions => ['exam_group_id =? && student_additional_field_id=?',@exam_group,@module])
    unless @module.nil?
      render(:update) do |page|
        page.replace_html 'modules', :partial => 'ans1', :object => @module
      end 
    else
      redirect_to final_exam_group_answers_path(@exam_group)
    end 
  end
  def ans1
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find_by_id(params[:exam_group_id])
    next_module = params[:next_module]
    @module = StudentAdditionalField.find_by_id(next_module)
    @answer = Answer.new 
    render(:update) do |page|
      page.replace_html 'modules', :partial => 'ans1', :object => @module
    end
  end
  def next
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find_by_id(params[:exam_group_id])
    @answer = Answer.new(params[:ans])
    @answer.answer = params[:answer]
    unless params[:answer].nil?
      @answer.visited = 1
    else 
      @answer.visited = 0
    end
    @answer.exam_group_id = @exam_group.id
    @answer.user_id = @user.id
    passed_question = params[:passed_question]
    @answer.questions_id = passed_question
    @question = Question.find_by_id(passed_question)
    @module = Question.find_by_sql ["SELECT student_additional_field_id FROM questions WHERE id=#{passed_question}"]
    student_additional_field_id = @module[0].student_additional_field_id
    b = params[:s].to_i - 1
    c = params[:s].to_i
    @questions = session[:ques]
    a = @questions[b] 
    d = @questions[c]
    @answer.modules_id = student_additional_field_id
      if params[:answer] == @question.is_answer
        @answer.marks = 1
      else
        @answer.marks = 0
      end
      
    if @answer.save
      last = @questions.last + 1
      @ans = Question.find_by_id(a)
      @fin = Answer.find_by_questions_id(a, :conditions => ['user_id=?',@user])
      @slno = params[:s].to_i 
      unless @fin.nil?
        if (@fin.visited == 1)
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ren', :object => @ans
          end
        else
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans', :object => @ans
          end
        end
      else
        unless @ans.nil?
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans', :object => @ans
          end
        else
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans2'
          end
        end
      end
    end
  end
  def ans
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group])
    @answer = Answer.new(params[:ans]) 
    passed_question = params[:passed_question]
    @module = Question.find_by_sql ["SELECT student_additional_field_id FROM questions WHERE id=#{passed_question}"]
    student_additional_field_id = @module[0].student_additional_field_id
    @questions = session[:ques]
    @slno = params[:s].to_i
    @fin = Answer.find_by_questions_id(passed_question, :conditions => ['user_id=?',@user])
    @ans = Question.find_by_id(passed_question) 
    render(:update) do |page|
      page.replace_html 'main', :partial => 'ans', :object => @ans
    end
  end
  def ren
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group])
    @answer = Answer.new(params[:ans]) 
    passed_question = params[:passed_question]
    @module = Question.find_by_sql ["SELECT student_additional_field_id FROM questions WHERE id=#{passed_question}"]
    student_additional_field_id = @module[0].student_additional_field_id
    @questions = session[:ques]
    @slno = params[:s].to_i
    @fin = Answer.find_by_questions_id(passed_question, :conditions => ['user_id=?',@user])
    @ans = Question.find_by_id(passed_question) 
    if (@fin == nil)
      render(:update) do |page|
        page.replace_html 'main', :partial => 'ans', :object => @ans
      end
    else
      render(:update) do |page|
        page.replace_html 'main', :partial => 'ren', :object => @ans
      end
    end
  end
  def update
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group_id])
    @answer = Answer.find_by_questions_id(params[:passed_question], :conditions => ['user_id=?',@user])
    @answer.answer = params[:answer]
    unless params[:answer].nil?
      @answer.visited = 1
    else 
      @answer.visited = 0
    end
    @answer.exam_group_id = @exam_group.id
    @answer.user_id = @user.id
    passed_question = params[:passed_question]
    @answer.questions_id = passed_question
    @question = Question.find_by_id(passed_question)
    @module = Question.find_by_sql ["SELECT student_additional_field_id FROM questions WHERE id=#{passed_question}"]
    student_additional_field_id = @module[0].student_additional_field_id
    b = params[:s].to_i - 1
    @questions = session[:ques]
    a = @questions[b] 
    @answer.modules_id = student_additional_field_id
      if params[:answer] == @question.is_answer
        @answer.marks = 1
      else
        @answer.marks = 0
      end

    if @answer.update_attributes(params[:ans])
      last = @questions.last + 1
      @ans = Question.find_by_id(a, :conditions => ['id not in (?)',last])
      @slno = params[:s].to_i
      @fin = Answer.find_by_questions_id(a, :conditions => ['user_id=?',@user])
      unless @fin.nil?
        
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ren', :object => @ans
        end
      else
        unless @ans.nil?
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans', :object => @ans
          end
        else
          render(:update) do |page|
            page.replace_html 'main', :partial => 'ans2'
          end
        end
      end
    end   
  end
  def sheet
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group_id])
    mod = @exam_group.modules.split(',')
    @modules = StudentAdditionalField.find(:all, :conditions => ['id in (?)',mod]) 
    respond_to do |format|
      format.html # show.html.erb
      format.msword { set_header('msword', "#{@current_user.full_name}-Resume.doc") }
    end

    
  end
  def result
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group_id])
    mod = @exam_group.modules.split(',')
    @modules = StudentAdditionalField.find(:all, :conditions => ['id in (?)',mod]) 
  end
  def ans2
    @total = StudentAdditionalField.count
    render(:update) do |page|
      page.replace_html 'main', :partial => 'ans2'
    end
  end
  def final
    @user = current_user
    @student = Student.find_by_admission_no(@user.username)
    @exam_group = ExamGroup.find(params[:exam_group_id])
    mod = @exam_group.modules.split(',')
    @modules = StudentAdditionalField.find(:all, :conditions => ['id in (?)',mod])
    @modu = []
    @modules.each do |m|
      mark = Answer.sum(:marks, :conditions => ['user_id = ? && modules_id = ?',@student.user_id,m.id])
      if mark < 15 
        @modu.push m 
      end
    end
    unless @modu.nil?
      b = params[:exam_group_id].to_i
      @xami = session[:xam]
      @exams = @xami[b]
    end
    @ques = Question.find(:all, :conditions => ['student_additional_field_id in (?)', @modules])
    @question = @ques.count
    @ans = Answer.find(:all, :conditions => ['modules_id in (?) && user_id=?', @modules,@user])
    @answers = @ans.count 
  end
  private
  def answered
    @i ||= current_user.answered_questions
  end
end