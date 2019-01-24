class AnswersController < ApplicationController

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end