require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  
  let(:question) {create(:question)}
  let(:another_question) {create(:question)}
  let(:user) { question.user }
  
  it 'has appropriate author_of? method (true condition)' do
    expect(user).to be_author_of(question)
  end  
  
  it 'has appropriate author_of? method (false condition)' do
    expect(user).not_to be_author_of(another_question)
  end 
  
end