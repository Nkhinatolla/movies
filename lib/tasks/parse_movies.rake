namespace :parse do
	desc "Parse movies"
	task :cities => :environment do
		require "nokogiri"
		require "open-uri"

		html = Nokogiri::HTML(open("http://kino.kz/new/schedule"))
		html.css("#city-select option").each do |city|
			puts "LOG: city = #{city['value']}"
			City.create(name: city.text, id: city['value'])
		end
	end
	task :cinemas => :environment do
		require "nokogiri"
		require "open-uri"
		html = Nokogiri::HTML(open("http://kino.kz/?ver=old"))
		cont = html.css(".container_left div")
		city = ""
		cont.each do |track|
			str = track.to_s
			if str.include? "menu_city"
				city = track.text
			elsif !str.include? "menu_items"
				if str.include? "menu_item"
					str = track.css("a")[0]['href'].to_s
					#puts "LOG: str = #{str}"
					cinemaid = ""
					str.each_char do |s| 
						cinemaid = cinemaid + s if s >= '0' && s <= '9' 
					end
					id = City.find_by_name(city).id
					#puts "LOG: cinemaid = #{cinemaid}"
					#puts "LOG: city = #{city}"
					#puts "LOG: id = #{id}"
					#puts "LOG: name = #{track.text}"
					Cinema.create(name: track.text, id: cinemaid.to_i, city_id: id)
				end
			end
		end
	end
	task :movies => :environment do
		require "nokogiri"
		require "open-uri"
		[0,1,2].each do |day|
			html = Nokogiri::HTML(open("http://kino.kz/cinema.asp?cinemaid=144&type=3&day=#{day}#top"))
			cont = html.css(".detail_content tr")
			cont.each do |track|
				str = track.to_s
				if str.include? "active"
					str = track.css("a")[0]['href'].to_s
					title = track.css("a")
					movieid = ""
					str.each_char do |s| 
						movieid = movieid + s if s >= '0' && s <= '9' 
					end
					html = Nokogiri::HTML(open("http://kino.kz/movie.asp?id=#{movieid}"))
					imgurl = "http://kino.kz" + html.css(".movie_big_poster img")[0]['src'].to_s
					texted = false
					stron = html.css(".movie_detail div")
					stron.each do |tracks|
						str = tracks.to_s
						if texted == false 
							if !str.include? "strong"
								texted = true
								desc = tracks.text
								Movie.create(id: movieid, title: title.text, description: desc, image_url: imgurl)
							end
						end
					end
				
					#puts "LOG: movieid:#{movieid},cinemaid:#{cinema.id},opn:#{opn},data:#{data}"
				end
			end
		end
	end

	task :sessions => :environment do
		require "nokogiri"
		require "open-uri"
		Cinema.all.each do |cinema|
			[0,1,2].each do |day|
				html = Nokogiri::HTML(open("http://kino.kz/cinema.asp?cinemaid=#{cinema.id}&type=3&day=#{day}#top"))
				cont = html.css(".detail_content")
				cont = cont.css("tr")
				#puts "LOG: Creating out.txt..."
				#out_file = File.new("out.txt", "w")
				#out_file.puts(cont)
				#out_file.close
				
				cont.each do |track|
					str = track.to_s
					if str.include? "active"
						data = track.css("td")[0].text
						opn = (str.include? "nonactive") ? false : true
						str = track.css("a")[0]['href'].to_s
						movieid = ""
						str.each_char do |s| 
							movieid = movieid + s if s >= '0' && s <= '9' 
						end
						#puts "LOG: movieid:#{movieid},cinemaid:#{cinema.id},opn:#{opn},data:#{data}"
						Session.create(movie_id: movieid, cinema_id: cinema.id, open: opn, time: data)
					end
				end
				puts "LOG: #{Session.count}"
			end
		end
	end
end
