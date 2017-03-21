describe "the signin process", :type => :feature do
  before :each do
    @user = FactoryGirl.create(:user)
  end

  it "signs me in" do
    visit new_user_session_path
    within("#new_user") do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
    end
    click_button 'Log in'
    expect(page).to have_content @user.email
  end
end