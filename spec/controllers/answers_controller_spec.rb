require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
    end
    let(:invalid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
    end
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new answer in DB' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end

      it 'render template create' do
        valid_answer_action
        expect(response).to render_template :create
      end

      it 'associates current user with answer' do
        valid_answer_action
        expect(assigns(:answer).user_id).to eq user.id
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save invalid answer to DB' do
        expect { invalid_answer_action }.not_to change(Answer, :count)
      end
     
      it 'renders temporary error handler' do
        invalid_answer_action
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      before do
        sign_in answer.user
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
      end
      
      it 'change answer attributes' do
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
    
    context 'update request from not author' do
      it 'not saves answer' do
        patch :update, params: { id: answer, answer: { body: 'Custom not factored answer' }, format: :js }
        answer.reload
        expect(answer.body).to eq answer.body
      end
    end
        
    context 'with invalid attributes' do
      before do
        sign_in answer.user
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
      end
      
      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq answer.body
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    let(:delete_action) { delete :destroy, params: { question_id: answer.question.id, id: answer }, format: :js }

    context 'deletes if request from the author' do
      before { login answer.user }

      it 'deletes the answer' do
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete_action
        expect(response).to render_template :destroy
      end
    end

    context 'try to delete from not author' do
      before { login user }

      it 'does not delete answer' do
        expect { delete_action }.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        delete_action
        expect(response).to render_template :destroy
      end
    end
  end
  
  
  describe 'PATCH #set_best' do
    let!(:question) { create(:question, :with_answers) }
    let(:best_answer) { question.answers[3] }
    
    context 'author sets best answer' do
      before do
        sign_in question.user
        patch :set_best, params: { id: best_answer, format: :js }
      end
      
      it 'assigns to @answer appropriate answer' do
        expect(assigns(:answer)).to eq best_answer
      end

      it 'sets the best attribute to answer' do
        expect(assigns(:answer).best).to eq(true)
      end

      it 'renders set best js template' do
        expect(response).to render_template :set_best
      end
    end
    
    context 'not author tries to set best' do
      it 'does not set the best attribute to answer' do
        login user
        patch :set_best, params: { id: best_answer, format: :js }
        expect(assigns(:answer).best).not_to eq(true)
      end
    end
  end  
end