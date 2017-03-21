require 'rails_helper'

describe PostsController do

  describe "GET :index" do 
    it "populates posts" do 
      post = create(:post)
      get :index
      expect( assigns(:posts) ).to eq([post])
    end
    it "renders the :index view" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET :show" do 
    before(:each) do
      @post = create(:post)
    end

    it "populates post" do 
      get :show, id: @post.id 
      expect( assigns(:post) ).to eq(@post)
    end
    it "renders the :show view" do
      get :show, id: @post.id
      expect(response).to render_template(:show)
    end
  end

  describe 'no authorization' do 

    before(:each) do 
      @post = create(:post)
    end

    context "GET :new with no login" do
      it "throws an error" do
        expect{get :new}.to raise_error(CanCan::AccessDenied)
      end
    end

    context "POST :create with no login" do
      it "throws an error" do
        expect{ post :create }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "GET :edit with no login" do
      it "throws an error" do
        expect{ get :edit, id: @post.id }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "PUT :update with no login" do
      it "throws an error" do
        expect{ put :update, id: @post.id }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "DELETE :destroy with no login" do
      it "throws an error" do
        expect{ delete :destroy, id: @post.id }.to raise_error(CanCan::AccessDenied)
      end
    end

  end

  describe 'authorization' do

    before(:each) do
      @user = create(:user)
      sign_in @user
      @post = create(:post, user_id: @user.id)
    end

    let(:attr) do
      { title: 'New Title', body: 'New Body'}
    end

    context "GET #new with valid login" do
      it "renders the :new view" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "POST :create with valid login" do
      it "saves the new post in the database" do
        expect{ post :create, post: @post.attributes }.to change(Post, :count).by(1)
      end
      it "redirects to the posts page" do
        post :create, post: @post.attributes
        expect(response).to redirect_to posts_path
      end
    end

    context "GET #edit with valid login" do
      it "renders the :edit view" do
        get :edit, id: @post.id
        expect(response).to render_template(:edit)
      end
    end

    context "PUT :update with valid login" do
      it "redirects to the posts page" do
        put :update, id: @post.id, post: attr 
        expect(response).to redirect_to posts_path
      end
      it 'changes the title' do
        put :update, id: @post.id, post: attr
        @post.reload
        expect(@post.title).to eql attr[:title]
      end
    end

    context "DELETE :destroy with valid login" do
      it "deletes the post in the database" do
        expect{ delete :destroy, id: @post.id }.to change(Post, :count).by(-1)
      end
    end
  end 

end