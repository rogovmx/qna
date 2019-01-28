require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  
  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do
      it 'saves the new question in the DB' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'doesnt save new question in the DB' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    
    let(:update_action) do
      patch :update, params: { id: question, question: { title: 'updated title', body: 'updated body' } }
    end

    context 'update with valid attributes' do
      before { update_action }

      it 'assigns to @question appropriate question' do
        expect(assigns(:question)).to eq question
      end

      it 'changes question with given attributes' do
        question.reload
        expect(question.title).to eq('updated title')
        expect(question.body).to eq('updated body')
      end

      it 'redirects to updated question' do
        expect(response).to redirect_to question
      end
    end

    context 'update with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not update question title with invalid attributes' do
        question.reload
        expect(question.title).to eq question.title
      end

      it 'does not update question body with invalid attributes' do
        question.reload
        expect(question.body).to eq question.body
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let(:delete_action) { delete :destroy, params: { id: question } }
    before { question }
    
    context 'deletes if request from author' do
      before { login question.user }
      
      it 'deletes the question' do
        expect { delete_action }.to change(Question, :count).by(-1)
      end

      it 'redirects to index of questions' do
        delete_action
        expect(response).to redirect_to questions_path
      end
    end
    
    context 'delete request from not author' do
      before { login(user) }
      it 'does not delete question' do
        expect { delete_action }.not_to change(Question, :count)
      end
    end
  end

end
