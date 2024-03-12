
class Family < ActiveRecord::Base
  has_paper_trail # https://github.com/airblade/paper_trail

  # TODO: helpers for dealing with mother and father separately
  # TODO: Rails 4 strong parameters instead of attr_accessible

  has_many :kids
  has_many :invoices

  accepts_nested_attributes_for :kids, reject_if: :all_blank


  before_validation :capitalize_names, on: [:create, :update]

  #scope :without_kids, -> { includes(:kids).where("kids.id is null") }
  # scope :has_kid, -> { includes(:kids).where("kids.id is not null") }
  scope :non_leads, -> { where('families.is_lead IS NULL OR families.is_lead != true') }
  scope :leads, -> { where(is_lead: true) }

  def capitalize_names
    self.mother_name = self.mother_name&.titleize
    self.father_name = self.father_name&.titleize
  end

  def self.has_nonzero_fee
    select do |family|
      family.has_nonzero_fee?
    end
  end

  def has_nonzero_fee?
    total_fee > 0
  end

  def total_fee
    kids.active.map(&:fee).sum.round
  end

  def emails
    [mother_email, father_email].compact
  end
  def phones
    [mother_phone, father_phone].compact
  end


  # Name parts
  def father_names
    father_name.split(" ") rescue nil
  end
  def mother_names
    mother_name.split(" ") rescue nil
  end

  # Forenames
  def mother_forenames
    mother_names[0...-1].join(" ")
  end
  def father_forenames
    father_names[0...-1].join(" ")
  end

  # Surnames
  def mother_surname
    mother_names[-1] rescue nil
  end
  def father_surname
    father_names[-1] rescue nil
  end

  def names
    [mother_name, father_name].compact
  end

  # Shorten if same surname
  def surnames
    if father_surname == mother_surname
      mother_surname
    else
      [mother_surname, father_surname].compact.join("/")
    end
  end

  def name
    surnames
  end

  def full_name
    names_as_sentence
  end

  def name_with_kids
    "#{kids.active.map(&:forename).to_sentence} #{name}"
  end

  def names_as_sentence
    if father_surname == mother_surname
      [mother_forenames, father_forenames].to_sentence + " " + mother_surname
    else
      names.to_sentence
    end
  rescue
    names.to_sentence
  end

end
