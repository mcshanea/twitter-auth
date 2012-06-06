require 'spec_helper'

describe EditionsController do

  describe "GET 'opf'" do
    it "should be successful" do
      get 'opf'
      response.should be_success
    end
  end

  describe "GET 'ncx'" do
    it "should be successful" do
      get 'ncx'
      response.should be_success
    end
  end

  describe "GET 'book'" do
    it "should be successful" do
      get 'book'
      response.should be_success
    end
  end

end
