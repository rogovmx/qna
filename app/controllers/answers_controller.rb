class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  helper_method :question
  helper_method :answer
 
  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(answer) && answer.update(answer_params)
       flash.now[:notice] = "Your answer have been successfully updated"
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash.now[:notice] = "Answer deleted"
    end 
  end

  def set_best
    if current_user.author_of?(question)
      answer.set_best
      @answers = answer.question.answers.reload
    end
  end
  
  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end


  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end