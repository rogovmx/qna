require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }

  it { should validate_presence_of :body }

  describe 'set_best answer method tests' do
    let(:question) { create(:question, :with_answers) }
    let(:answer1) { question.answers[1] }
    let(:answer2) { question.answers[2] }

    context 'best answer is not set' do
      it { expect(answer1).to_not be_best }
      it { expect(answer2).to_not be_best }
    end

    context 'best answer set' do
      before { answer1.set_best }

      it { expect(answer1).to be_best }
      it { expect(answer2).to_not be_best }
    end

    context 'best answer change' do
      before do
        answer1.set_best
        answer2.set_best
        answer1.reload
        answer2.reload
      end

      it { expect(answer1).to_not be_best }
      it { expect(answer2).to be_best }
    end
  end


end
