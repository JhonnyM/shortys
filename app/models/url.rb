class Url < ApplicationRecord

  validates_presence_of :url, :access_count
  validates_format_of :url, with:  /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  scope :top, -> (order, limit) { order(access_count: order).limit(limit) }
  ALPHABET = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join.freeze

  after_create :generate_short_url
  after_create :set_access

  def generate_short_url
    # use the bijective function to enconde the url
    self.short_url = self.bijective_encode(self.id)
    self.save
  end

  def find_duplicate
    u = Url.find_by_sanitize_url(self.sanitize_url)
  end

  def new_url?
    u = find_duplicate
    if u.blank?
      true
    else
      increase_count(u)
      false
    end
  end

  def set_access
    self.access_count = self.access_count + 1
    self.save
  end

  def increase_count(u)
    u.access_count += 1
    u.save!
  end

  def sanitize
    self.url.strip!
    self.sanitize_url = self.url.gsub(/(https?:\/\/)/, "")
    self.sanitize_url.slice!(-1) if self.sanitize_url[-1] == "/"
    self.sanitize_url = "http://#{self.sanitize_url}"
  end

  def bijective_encode(i)
    return ALPHABET[0] if i == 0
    s = ''
    base = ALPHABET.length
    while i > 0
      s << ALPHABET[i.modulo(base)]
      i /= base
    end
    s.reverse
  end

  def self.bijective_decode(s)
    i = 0
    base = ALPHABET.length
    s.each_char { |c| i = i * base + ALPHABET.index(c) }
    i
  end


end
