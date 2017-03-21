require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'no authorization' do 

    before(:each) do 
      @comment = create(:comment)
    end

    context "POST :create with no login" do
      it "throws an error" do
        expect{ post :create, format: :js }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "GET :edit with no login" do
      it "throws an error" do
        expect{ get :edit, id: @comment.id, format: :js  }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "PUT :update with no login" do
      it "throws an error" do
        expect{ put :update, id: @comment.id, format: :js  }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "DELETE :destroy with no login" do
      it "throws an error" do
        expect{ delete :destroy, id: @comment.id, format: :js  }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

  describe 'authorization' do

    before(:each) do
      @user = create(:user)
      sign_in @user
      @post = create(:post, user_id: @user_id)
      @comment = create(:comment, user_id: @user.id, post_id: @post.id)
    end

    let(:attr) do
      { body: 'New Body'}
    end

    context "POST :create with valid login" do
      it "saves the new post in the database" do
        expect{ post :create, comment: @comment.attributes, format: :js }.to change(Comment, :count).by(1)
      end
    end

    context "GET #edit with valid login" do
      it "renders the :edit view" do
         xhr :get, :edit, id: @comment.id
        expect(response).to render_template(:edit)
      end
    end

    context "PUT :update with valid login" do
      it "redirects to the posts page" do
        put :update, id: @comment.id, comment: attr, format: :js
        expect(response).to render_template(:update)
      end
      it 'changes the body' do
        put :update, id: @comment.id, comment: attr, format: :js
        @comment.reload
        expect(@comment.body).to eql attr[:body]
      end
    end

    context "DELETE :destroy with valid login" do
      it "deletes the comment in the database" do
        expect{ delete :destroy, id: @comment.id, format: :js }.to change(Comment, :count).by(-1)
      end
    end
  end 

end
