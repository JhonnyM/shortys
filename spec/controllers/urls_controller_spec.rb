require 'rails_helper'

RSpec.describe UrlsController, type: :controller do

  describe "GET #index" do
    it "assigns a new @url" do
      get :index
      expect(assigns(:url)).to be_a_new(Url)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before :each do
      @url = create(:url, url: "twitch.com")
      @url.sanitize
      @url.save
    end

    it "assigns the url to @url" do
      get :show, params: { short_url: @url.short_url }
      expect(assigns(:url)).to eq @url
    end
    it "redirects to the sanitized url" do
      get :show, params: { short_url: @url.short_url }
      expect(response).to redirect_to(@url.sanitize_url)
    end
  end

  describe "GET #shorty" do
    before :each do
      @url = create(:url, url: "twitch.com")
      @url.sanitize
      @url.save
    end
    it "assigns the url to @url" do
      get :shorty, params: { short_url: @url.short_url }
      expect(assigns(:url)).to eq(@url)
    end

    it "renders the shortened view" do
      get :shorty, params: { short_url: @url.short_url }
      expect(response).to render_template :shorty
    end
  end

  describe "POST #create" do
    context "with valid params" do
      context "with a new url" do
        it "creates a new url entry" do
          expect{
            post :create, params: { url: attributes_for(:url) }
          }.to change(Url, :count).by(1)
        end
        it "redirects to the shortened url  page" do
          post :create, params: { url: attributes_for(:url) }
          expect(response).to redirect_to shorty_path(assigns[:url].short_url)
        end
      end
    end
    context "with invalid attributes" do
      it "renders the :index template" do
        post :create, params: { url: attributes_for(:url, url: nil) }
        expect(response).to render_template :index
      end
    end
  end
end
