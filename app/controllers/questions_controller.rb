class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  helper_method :question

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully added'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(question) && question.update(question_params)
      flash.now[:notice] = "Your question successfully updated"
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: "Question deleted"
    else
      redirect_to question, notice: "No access to delete this question"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_user.questions.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
