require 'rails_helper'

RSpec.describe Url, type: :model do

  it "is valid with a valid url" do
    url = build(:url)
    expect(url).to be_valid
  end

  it "cant be blank with nil" do
    url = build(:url, url: nil)
    url.valid?
    url.errors[:url].should include("can't be blank")
  end

  it "is invalid without a url" do
    url = build(:url, url: nil)
    url.valid?
    url.errors[:url].should include("is invalid")
  end

  it "is invalid with an invalid URL" do
    url = build(:url, url: "test")
    url.valid?
      url.errors[:url].should include("is invalid")
  end

  describe "method" do
    before :each do
      @twitch_url = create(:url, url: "http://www.twitch.com")
      @twitch_url.sanitize
      @twitch_url.save
    end

    it "#increases the access_count when the url is saved" do
      expect(@twitch_url.access_count).to be(1)
    end

    it "#increases the access_count when the url is accessed" do
      url = build(:url, url: "http://www.twitch.com")
      url.sanitize
      expect(@twitch_url.access_count).to be(1)
    end

    it "#generate_short_url always generates a short_url that is not in the database" do
    end

    it "#find_duplicate finds a duplicate in the database" do
      url = build(:url, url: "http://www.twitch.com")
      url.sanitize
      expect(url.find_duplicate).to eq(@twitch_url)
    end

    context "#new_url?" do
      it "returns false if the URL is already present in the database" do
        url = build(:url, url: "http://www.twitch.com")
        url.sanitize
        expect(url.new_url?).to eq(false)
      end

      it "returns true if the URL is not found in the database" do
        url = build(:url, url: "www.toto.com")
        url.sanitize
        expect(url.new_url?).to eq(true)
      end
    end

    context "#sanitize" do

      it "strips leading spaces from url" do
        url = build(:url, url: '  http://www.google.com')
        url.sanitize
        expect(url.url).to eq('http://www.google.com')
      end

      it "strips trailing spaces from url" do
        url = build(:url, url: 'http://www.google.com  ')
        url.sanitize
        expect(url.url).to eq('http://www.google.com')
      end

    end
  end

  describe "is valid with the follwing urls:" do

    it "http://www.google.com" do
      url = build(:url, url: "http://www.google.com")
      expect(url).to be_valid
    end

    it "http://www.google.com/" do
      url = build(:url, url: "http://www.google.com/")
      expect(url).to be_valid
    end

    it "https://www.google.com" do
      url = build(:url, url: "https://www.google.com")
      expect(url).to be_valid
    end

    it "https://google.com" do
      url = build(:url, url: "https://google.com")
      expect(url).to be_valid
    end

    it "www.google.com" do
      url = build(:url, url: "google.com")
      expect(url).to be_valid
    end

    it "google.com" do
      url = build(:url, url: "google.com")
      expect(url).to be_valid
    end

    it "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z" do
      url = build(:url, url: "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z")
      expect(url).to be_valid
    end

    it "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE" do
      url = build(:url, url: "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE")
      expect(url).to be_valid
    end

    it "my-google.com" do
      url = build(:url, url: "my-google.com")
      expect(url).to be_valid
    end

    it "https://en.wikipedia.org/wiki/HTML_element#Anchor" do
      url = build(:url, url: "https://en.wikipedia.org/wiki/HTML_element#Anchor")
      expect(url).to be_valid
    end

    it "https://www.sucursalelectronica.com/redir/showLogin.go" do
      url = build(:url, url: "https://en.wikipedia.org/wiki/HTML_element#Anchor")
      expect(url).to be_valid
    end


  end
end
