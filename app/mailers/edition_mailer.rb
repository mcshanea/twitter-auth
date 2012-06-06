class EditionMailer < ActionMailer::Base
  default :from => "editions@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.edition_mailer.send_edition.subject
  #
  def send_edition(emails, ebook_path)
    @greeting = "Hi"

    mail.attachments["ebook-#{Time.now.to_s}.mobi"] = {:mime_type => 'application/x-mobipocket-ebook',
                                    :content => File.read(ebook_path)}

    mail :to => emails
  end
end
