require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user) { create(:user) }
  
  describe 'POST #create' do
    let(:valid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
    end
    let(:invalid_answer_action) do
      post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
    end
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new answer in DB' do
        expect { valid_answer_action }.to change(question.answers, :count).by(1)
      end

      it 'redirects to matching question' do
        valid_answer_action
        expect(response).to redirect_to question
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

      it 'renders the new view' do
        invalid_answer_action
        expect(response).to render_template 'questions/show'
      end
    end
  end
 
  describe 'DELETE #destroy' do
    before { answer }
    
    let(:delete_action) { delete :destroy, params: { question_id: answer.question.id, id: answer } }
    
    context 'deletes if request from the author' do 
      before { login answer.user }
      
      it 'deletes the answer' do
        expect { delete_action }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete_action
        expect(response).to redirect_to answer.question
      end
    end
    
    context 'try to delete from not author' do
      before { login user }
      
      it 'does not delete answer' do
        expect { delete_action }.not_to change(Answer, :count)
      end
      
      it 'redirects to question' do
        delete_action
        expect(response).to redirect_to answer.question
      end
    end 
  end

end