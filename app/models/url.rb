class Url < ApplicationRecord

  validates_presence_of :url, :access_count
  validates_format_of :url, with:  /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  scope :top, -> (order, limit) { order(access_count: order).limit(limit) }
  validates_uniqueness_of :short_url

  after_create :generate_short_url
  after_create :set_access

  def generate_short_url
    # we generate a base 36 token
    self.short_url = self.id.to_s(36)
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

end
