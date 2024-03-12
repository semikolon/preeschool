require 'adroit-age'

# MAXIMUM_INCOME = (@cms_site.snippets.find_by_identifier('maxtaxa').content.to_i rescue 43700)
# DEFAULT_INCOME = MAXIMUM_INCOME
# MAXIMUM_FEE = MAXIMUM_INCOME * 0.03

class Kid < ActiveRecord::Base
  belongs_to :family

  has_paper_trail # https://github.com/airblade/paper_trail

  scope :by_age, -> { order(ssn: :desc) }
  scope :orphan, -> { where("family_id is null") }
  scope :has_family, -> { where("family_id is not null") }
  scope :by_name, -> (name) { where("full_name ilike ?", "%#{name}%")}

  def self.siblings(family_id)
    where(family_id: family_id)
  end
  def siblings
    self.class.siblings(self.family_id).where("id != ?", self.id)
  end

  before_validation :complete_ssn, on: [:create, :update]
  before_validation :ensure_start_date, on: [:create, :update]
  before_validation :ensure_end_date, on: [:create, :update]

  validates_presence_of :full_name, :start_date
  validates_length_of :full_name, minimum: 3

  validates_presence_of :ssn
  with_options allow_blank: true do |v|
    v.validates_length_of :ssn, is: 13  # 20080101-1234
    v.validates_uniqueness_of :ssn
  end

  def self.maximum_income
    site = Comfy::Cms::Site.first
    # ap Comfy::Cms::Site.all
    site.snippets.find_by_identifier('maxtaxa').content.to_i rescue 43700
  end
  def self.default_income
    self.maximum_income
  end
  def self.maximum_fee
    self.maximum_income * 0.03
  end

  # def self.forenames
  #   map(&:forename).to_sentence
  # end

  def names
    full_name.split(" ") rescue nil
  end

  def forename
    names[0] rescue nil
  end

  def forenames
    names[0...-1].join(" ") rescue nil
  end

  def surname
    names[-1] rescue nil
  end

  def date_of_birth
    Date.parse(self.ssn[0,8]) rescue nil
  end

  def age_now
    date_of_birth.find_age
  end
  def age
    age_by_end_of_year
  end
  def age_by_end_of_year
    date_of_birth.find_age_by_end_of_year
  end
  def age_on(date)
    date_of_birth.find_age_on(date)
  end

  def default_end_date
    # Should be July the year of their 6th birthday
    # FIXME: make sure logic is right - should we really
    # use age_by_end_of_year here?
    (date_of_birth + 6.years).change(month: 7, day: 1)
    # self.start_date + 2.years
  end

  def self.active
    # self.where("now() >= :start_date AND now() <= :end_date",
    #   { start_date: :start_date, end_date: :end_date })
      #
      # Client.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
    select{ |kid| kid.active? }
  end
  def self.inactive
    select{ |kid| !kid.active? }
  end

  # default_scope :active

  def active?
    # TODO rewrite to SQL query
    return false if pending?
    Date.today.between?(start_date, end_date)
  end

  def big # TODO add in view
    age >= 4 # Should this maybe not use age_by_end_of_year?
  end

  # Allmän förskola
  def free_15_hour_week
    september_of_3yob = (date_of_birth + 3.years).change(month: 9, day: 1)
    return age >= 3 &&
      Date.today >= september_of_3yob &&
      Date.today.month != 8
  end

  def fee_percent
    return 0.03 if birth_order.nil?
    pc =
      case birth_order
      when 1 then 0.03
      when 2 then 0.02
      when 3 then 0.01
      else 0
      end
    pc = pc * 0.7 if free_15_hour_week
    pc.round(3)
  end

  def relevant_income
    [family.income || Kid::default_income, Kid::maximum_income].min
  end

  def fee
    return 0 unless active?
    return 0 unless family
    kid_fee = fee_percent * relevant_income
    if family.parent_at_home?
      if free_15_hour_week
        kid_fee = 0
      else
        kid_fee = kid_fee * 0.6
      end
    end
    kid_fee.round(2)
  end

  def birth_order
    return nil unless family
    index = family.kids.order(ssn: :desc).active
      .map(&:id)
      .quick_index(self.id)
    index.to_i + 1
  end


  # Kommunbidrag

  def self.subsidy_break_date # July 1st
    Date.today.change(month: 7, day: 1)
  end

  def subsidy_age
    age_on(Kid.subsidy_break_date)
  end

  def subsidy_young?
    subsidy_age <= 3
  end

  def subsidy
    subsidy_young? ? Kid.subsidy_for_younger : Kid.subsidy_for_older
  end

  def self.current_subsidies_total
    Kid.active.sum(&:subsidy)
  end

  def self.subsidy_for_younger
    (@cms_site.snippets.find_by_identifier('bidrag-yngre-barn').content.to_f rescue 10700.42)
  end
  def self.subsidy_for_older
    (@cms_site.snippets.find_by_identifier('bidrag-aeldre-barn').content.to_f rescue 8047.83)
  end

  protected

    def complete_ssn
      # self.ssn = self.ssn.gsub(/\D/) # TODO: strip of all but numbers and "-"
      if self.ssn and self.ssn.is_a?(String) and self.ssn.length == 8
        self.ssn = self.ssn + '-0000'
      end
    end

    def ensure_start_date
      if !self.start_date?
        self.start_date = Date.today
      end
    end

    def ensure_end_date
      if self.start_date and !self.end_date?
        self.end_date = default_end_date
      end
    end

end
