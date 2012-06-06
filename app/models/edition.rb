require 'kindlegen'

class Edition
  include Rails.application.routes.url_helpers
  
  @queue = :create_user_edition

  def self.perform(user_id)
  	user = User.find(user_id)

    file_path = "#{Rails.root}/data/editions/#{user.id}"

    require 'open-uri'
    require 'fileutils'
    require 'iconv'
    FileUtils.mkdir_p file_path

    writeOut = open(file_path+'/content.html', "wb:ISO-8859-1")
    writeOut.write(Iconv.iconv("iso8859-1//IGNORE", "UTF-8", open("http://localhost:3000/editions/ebook/#{user.id}").read).join)
    writeOut.close

    Kindlegen.run( "#{file_path}/content.html", "-o", "#{user.name}.mobi" )

    ebook_path = "#{file_path}/#{user.name}.mobi"

    #email_addresses = ['mcshane@kernelmag.com']
	#EditionMailer.send_ebooks(email_addresses, ebook_path).deliver unless email_addresses.blank?

    #FileUtils.rm_r Dir.glob("#{file_path}/*")
  end
end