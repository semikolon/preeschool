# encoding: utf-8
require 'rails_helper'
# Time is April 1, 2015, 10.05 AM

RSpec.describe Family, type: :model do
  before(:all) do
    @family = Family.create!(
      mother_name: "Ensamma Mamman Olsson",
      mother_email: "ensammamamman@test.se",
      comment: ":("
    )
    @kid = Kid.create!(
      family: @family,
      ssn: "20120102-0714",
      full_name: "Ena Barnet",
      start_date: Date.new(2012,7,1)
    )
    @kid2 = Kid.create!(
      family: @family,
      ssn: "20131023-0717",
      full_name: "Andra Barnet",
      start_date: Date.new(2013,7,1)
    )
    @kid3 = Kid.create!(
      family: @family,
      ssn: "20140923-0716",
      full_name: "Tredje Barnet",
      start_date: Date.new(2014,7,1)
    )
  end

  it "should capitalize names" do
    lcfam = Family.create!(
      mother_name: "anna larsson",
      mother_email: "anna@larsson.se",
      father_name: "johan larsson",
      father_email: "johan@larsson.se"
    )
    expect(lcfam.mother_name).to eq 'Anna Larsson'
    expect(lcfam.father_name).to eq 'Johan Larsson'
  end

  it "should have kids" do
    expect(@kid.family).to eq(@family)
    expect(@family.kids.by_age).to eq([@kid3, @kid2, @kid])
  end

  it "should have the right fee percentage for oldest kid" do
    expect(@kid.birth_order).to eq(3)
    expect(@kid.fee_percent).to eq(0.01)
  end

  it "should have the right fee percentage for middle kid" do
    expect(@kid2.birth_order).to eq(2)
    expect(@kid2.fee_percent).to eq(0.02)
  end

  it "should have the right fee percentage for youngest kid" do
    expect(@kid3.birth_order).to eq(1)
    expect(@kid3.fee_percent).to eq(0.03)
  end

  it "should have the right fee for oldest kid" do
    expect(@kid.fee).to eq(437)
  end

  it "should have the right fee for middle kid" do
    expect(@kid2.fee).to eq(874)
  end

  it "should have the right fee for youngest kid" do
    expect(@kid3.fee).to eq(1311)
  end

  it "should have the right total fee" do
    expect(@family.total_fee).to eq(2622)
  end

  it "should have the right fees for family with no income set and a parent_at_home" do
    @family.update_attributes(parent_at_home: true)
    # ap @family
    expect(@kid.fee).to eq(262.2)
    expect(@kid2.fee).to eq(524.4)
    expect(@kid3.fee).to eq(786.6)
  end

  it "should have the right fees for family with 10k income and a parent_at_home" do
    @family.update_attributes(parent_at_home: true)

    @family.update_attributes(income: nil)
    expect(@kid3.fee).to eq(786.6)
    @family.update_attributes(income: 10000)
    expect(@kid3.fee).to eq(180)
  end

  it "should have the right fees for family with 10k income and no parent_at_home" do
    @family.update_attributes(parent_at_home: nil)

    @family.update_attributes(income: nil)
    expect(@kid3.fee).to eq(1311)
    @family.update_attributes(income: 10000)
    expect(@kid3.fee).to eq(300)
  end

  it "should have the right fees for family with income of 40k (just below maximum)" do
    @family.update_attributes(parent_at_home: nil)

    @family.update_attributes(income: 40000)
    expect(@kid.fee).to eq(400)
    expect(@kid3.fee).to eq(1200)
  end

  it "should have capped fees for family with income above maximum" do
    @family.update_attributes(parent_at_home: nil)

    @family.update_attributes(income: 45000)
    expect(@kid.fee).to eq(437)
    expect(@kid3.fee).to eq(1311)

    @family.update_attributes(income: 50000)
    expect(@kid.fee).to eq(437)
    expect(@kid3.fee).to eq(1311)
  end

  it "should have the right fees for family with an older inactive kid" do
    @kid.update_attributes(end_date: Date.new(2015,3,1))
    expect(@kid.active?).to be false
    expect(@kid2.active?).to be true
    expect(@kid3.active?).to be true

    expect(@kid.fee).to eq(0)
    expect(@kid2.fee).to eq(874)
    expect(@kid3.fee).to eq(1311)
  end

  it "should have the right fees for family with a younger inactive kid" do
    @kid.update_attributes(end_date: Date.new(2016,3,1))
    @kid3.update_attributes(end_date: Date.new(2015,3,1))
    expect(@kid.active?).to be true
    expect(@kid2.active?).to be true
    expect(@kid3.active?).to be false

    expect(@kid.fee).to eq(874)
    expect(@kid2.fee).to eq(1311)
    expect(@kid3.fee).to eq(0)
  end

  it "should have scope for nonzero fee" do
    family = Family.create!(
      mother_name: "Rudolf Andersson",
      mother_email: "rudolf@test.se",
    )
    kid = Kid.create!(
      family: family,
      ssn: "20050102-0001",
      full_name: "Sune Andersson",
      start_date: Date.new(2005,7,1)
    )

    expect(Family.all).to eq([@family, family])
    expect(Family.has_nonzero_fee).to eq([@family])
  end

  it "should be able to do a diff detailing historical changes" do
    expect(@family.income).to eq(50000)
    jump(2015, 4, 4)
    @family.update_attributes(income: 30000)
    jump(2015, 4, 6)
    @family.update_attributes(income: 60000)
    expect(@family.versions.count).to eq(3)
    history = @family.history
    # ap history
    expect(history).to be_a(Array)
    expect(history[1]["income"]).to eq([50000, 30000])
    expect(history[1]["updated_at"].to_date).to eq(Date.new(2015,4,4))
    expect(history.last["income"]).to eq([30000, 60000])
    expect(history.last["updated_at"].to_date).to eq(Date.new(2015,4,6))
  end

  def jump(year, month, day)
    Timecop.travel(Time.local(year, month, day, 10, 1, 0))
  end

end