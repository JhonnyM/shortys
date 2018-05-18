class Url < ApplicationRecord

	validates_presence_of :url, :access_count
	validates_format_of :url, with: /\A#{URI::regexp(['http', 'https'])}\z/

	before_create :generate_short_url
	after_create :set_access


	def generate_short_url
		chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
    	# here we assign a short_url
    	self.short_url = 6.times.map{chars.sample}.join
    	# to check if the short url already exist
		self.short_url = 6.times.map{chars.sample}.join until Url.find_by_short_url(self.short_url).nil?
	end

	def find_duplicate
	    Url.find_by_sanitized_url(self.sanitize_url)
	end

	def new_url?
		find_duplicate.nil?
	end

	def set_access
		self.access_count =  self.access_count + 1
	end

    def sanitize
	    self.url.strip!
	    self.sanitize_url = self.url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
	    self.sanitized_url.slice!(-1) if self.sanitize_url[-1] == "/"
	    self.sanitize_url = "http://#{self.sanitize_url}"
	end

end
