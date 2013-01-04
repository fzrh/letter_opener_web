require 'spec_helper'

describe LetterOpenerWeb::LettersController do
  describe 'GET index' do
    before do
      LetterOpenerWeb::Letter.stub(search: :all_letters)
      get :index
    end
    it { should assign_to(:letters).with(:all_letters) }
  end

  describe 'GET show' do
    let(:id)         { 'an-id' }
    let(:rich_text)  { "rich text href=\"plain.html\"" }
    let(:plain_text) { "plain text href=\"rich.html\"" }
    let(:letter)     { mock(:letter, rich_text: rich_text, plain_text: plain_text, id: id) }

    before do
      LetterOpenerWeb::Letter.stub(find: letter)
    end

    context 'rich text version' do
      before { get :show, id: id, style: 'rich' }

      it "returns letter's rich text contents" do
        response.body.should =~ /^rich text/
      end

      it 'fixes plain text link' do
        response.body.should_not =~ /href="plain.html"/
        response.body.should =~ /href="#{Regexp.escape letter_path(id: letter.id, style: 'plain')}"/
      end
    end

    context 'plain text version' do
      before { get :show, id: id, style: 'plain' }

      it "returns letter's plain text contents" do
        response.body.should =~ /^plain text/
      end

      it 'fixes rich text link' do
        response.body.should_not =~ /href="rich.html"/
        response.body.should =~ /href="#{Regexp.escape letter_path(id: letter.id, style: 'rich')}"/
      end
    end
  end
end