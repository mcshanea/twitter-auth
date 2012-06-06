require 'net/http'

module EditionsHelper
 
	def convert_to_full(tinyurl)
		begin
		   return HTTPClient.new.head(tinyurl).header['Location'][0]
   		rescue

   		end
	end

	def get_links(tweet)
		mc = tweet.scan(/\b(?:https?:\/\/|www\.)\S+\b/)
		mc
	end

	def show_page(url)
		#begin
			#source = open(url).read
			agent = Mechanize.new
			mech = agent.get(url)
			return unless mech.uri.path.count('/') > 2
			#p mech.at('body').to_s
			page = Readability::Document.new(mech.at('body').to_s)
			result = ""
			unless page.content.scan(/\w+/).size < 500
				result = "<h2>#{mech.title}</h2>"
				#image = mech.images.first unless mech.images.blank?
				#result << "<div><img src=\"#{image}\" /></div>" unless image.blank?
				result << page.content
			end

			result.html_safe unless result.blank?
		#rescue
		#  puts "Could not retrieve url"
		#end
	end

	def get_timeline_urls(timeline)
		titles = []
		result = ""
		agent = Mechanize.new
    	timeline.each do |tweet|
    		tweet_urls = []
    		urls = []
    		m = get_links(tweet.text)
    		m.each do |b_url|
    			begin
	    			mech = agent.get(convert_to_full(b_url))
	    			next unless titles.index(mech.title).nil?
	    			path = mech.uri.path
					next if path.nil? || path.count('/') < 3
					#if tweet.retweeted == true || tweet.text[0,3] == "RT "
					page = Readability::Document.new(mech.at('body').to_s)
					titles << mech.title
					page_size = page.content.scan(/\w+/).size
					if page_size > 250
						result << "<h2>#{mech.title}</h2>"
						result << "<div>Original: <a href=\"#{mech.uri.to_s}\">#{mech.uri.to_s}</a></div>"
						result << page.content
					end
				rescue
	   			end
			end
			#tweet_urls << [:tweet_text => tweet.text, :urls => urls] unless urls.blank?
		end

		result.html_safe unless result.blank?
  	end

	def show_mech_page(url)
		agent = Mechanize.new
		page = agent.get(url)
		return unless page.uri.path.count('/') > 3
		p page.links.count
		#result = "Original source: #{url}"
		result = page.title
		#author = page.link_with(:href => /author/)
		#result << "By <a href='#{author.href}'>#{author.text}</a>" unless author.nil?
		unless page.search("article").blank?
			result << page.search("article p").to_s
		else
			result << page.search("div p").to_s
			#result << page.search("//div[substring(@id, 1, 7) = 'content']").to_s

		end
		Distillery.distill(result.to_s).html_safe
	end

	def show_best_page(url)
		p url
		thepage = MechanizeContent::Parser.new("http://www.joystiq.com/2010/03/19/mag-gets-free-trooper-gear-pack-dlc-next-week/")

		p thepage.url

		result = "<h2>#{thepage.best_title}</h2>"
		result << "<div>#{thepage.best_text}</div>"

		result.html_safe
	end

	def link_urls_and_users(s)
      #regexps
      url = /( |^)http:\/\/([^\s]*\.[^\s]*)( |$)/
      user = /@(\w+)/
      hashtag = /#(\w+)/

      #replace @usernames with links to that user
      s.gsub! user, '<a href="http://twitter.com/\1" >@\1</a>'
            
      s.gsub! hashtag, '<a href="http://twitter.com/search?q=%23\1" >#\1</a>'
      
      #replace urls with links
      s.gsub! url, ' <a href="http://\2" >\2</a> '

      s
  end
end
