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
		
	end

	task sessions: :environment do
		require "nokogiri"
		require "open-uri"
		
	end
end
