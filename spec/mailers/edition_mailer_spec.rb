require "spec_helper"

describe EditionMailer do
  describe "send_edition" do
    let(:mail) { EditionMailer.send_edition }

    it "renders the headers" do
      mail.subject.should eq("Send edition")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
