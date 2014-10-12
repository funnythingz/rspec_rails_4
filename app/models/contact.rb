class Contact < ActiveRecord::Base
  has_many :phones
  accepts_nested_attributes_for :phones

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phones, length: { is: 3 }

  def name
    [firstname, lastname].join(' ')
  end

  def self.by_letter(letter)
    where("lastname LIKE ?", "#{letter}%").order(:lastname)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |contact|
        csv << contact.attributes.values_at(*column_names)
      end
    end
  end

  # TODO:
  def hidden

  end
end
