# encoding: utf-8
require 'rails_helper'
# Time is April 1, 2015, 10.05 AM

RSpec.describe Kid, type: :model do
  before(:all) do
    make_kids
  end

  after(:all) do
    clear_tables
  end

  context 'should scope correctly' do
    before :all do
      make_extra_kids
    end

    it "should count all kids (default scope)" do
      count = Kid.count
      expect(count).to be 4
    end

    it "should count active kids" do
      count = Kid.active.count
      expect(count).to be 1
    end

    it "should count inactive kids" do
      count = Kid.inactive.count
      expect(count).to be 3
    end
  end

  it "should be inactive after end date" do
    @kid.update_attributes(end_date: Date.new(2015,3,1))
    expect(@kid.pending?).to be false
    expect(@kid.active?).to be false
  end

  it "should be inactive before start date" do
    kid = Kid.create(
      ssn: "20141231-1213",
      full_name: "Barnet",
      start_date: Date.new(2015,4,3)
    )
    expect(kid.pending?).to be false
    expect(kid.active?).to be false
  end

  it "should have a maximum_income method" do
    expect(Kid::maximum_income).to be 43700
  end

  it "should be big when they've turned 4 years old" do
    expect(@kid.big).to be true

    little_kid = Kid.create(
      ssn: "20120510-0717",
      full_name: "Fredrik Bränström",
      start_date: Date.new(2012,7,1)
    )
    # p Date.today, (Date.today - little_kid.date_of_birth).to_f/365
    # p little_kid.age_now, little_kid.age
    expect(little_kid.age_now).to eq(2)
    expect(little_kid.age).to eq(3)
    expect(little_kid.big).to be false
  end

  it "should have AFSK when they're 5 years old" do
    expect(@kid.free_15_hour_week).to be true

    kid = Kid.create(
      ssn: "20100123-1213",
      full_name: "Olle Barn"
    )
    expect(kid.free_15_hour_week).to be true
  end

  it "should not have AFSK when they're 2 years old" do
    kid = Kid.create(
      ssn: "20130304-0000",
      full_name: "Strumpebarn"
    )
    expect(kid.free_15_hour_week).to be false
  end

  it "should not have AFSK when they're just almost 3 years old" do
    kid = Kid.create(
      ssn: "20130101-1213",
      full_name: "Andra Barnet"
    )
    expect(kid.free_15_hour_week).to be false
  end


  it "should not have AFSK when they're 3 years old before September" do
    kid = Kid.create(
      ssn: "20121231-1213",
      full_name: "Maja Barn"
    )
    expect(kid.free_15_hour_week).to be false
  end

  it "should not have AFSK when they're 3 years old after September" do
    jump(2015, 9, 1)

    kid = Kid.create(
      ssn: "20121231-1213",
      full_name: "Maja Barn"
    )
    expect(kid.free_15_hour_week).to be true

    jump(2016, 4, 1)
    expect(kid.free_15_hour_week).to be true

    jump(2018, 4, 1)
    expect(kid.free_15_hour_week).to be true
  end

  it "should never have AFSK if it's August" do
    jump(2015, 8, 1)
    expect(Kid.any?(&:free_15_hour_week)).to be false
  end

  it "should be possible to have AFSK if it's not August" do
    jump(2015, 6, 1)
    expect(Kid.any?(&:free_15_hour_week)).to be true
  end

  it "should be able to do a diff detailing historical changes" do
    expect(@kid.comment).to eq(nil)
    jump(2015, 4, 4)
    @kid.update_attributes(comment: 'först')
    jump(2015, 4, 6)
    @kid.update_attributes(comment: 'sedan')
    expect(@kid.versions.count).to eq(3)
    history = @kid.history
    # ap history
    expect(history).to be_a(Array)
    expect(history[1]["comment"]).to eq([nil, 'först'])
    expect(history[1]["updated_at"].to_date).to eq(Date.new(2015,4,4))
    expect(history.last["comment"]).to eq(['först', 'sedan'])
    expect(history.last["updated_at"].to_date).to eq(Date.new(2015,4,6))
  end

  def jump(year, month, day)
    Timecop.travel(Time.local(year, month, day, 10, 1, 0))
  end

  def make_kids
    @kid = Kid.create(
      ssn: "20090423-0001",
      full_name: "Fredrik Bränström",
      start_date: Date.new(2012,7,1)
    )
  end

  def make_extra_kids
      Kid.create(
        ssn: "20121104-1110",
        full_name: "Knut Barn",
        pending: true
      )
      Kid.create(
        ssn: "20121201-1120",
        full_name: "Sven Barn",
        start_date: Date.new(2013,8,1),
        pending: true
      )
      Kid.create(
        ssn: "20130128-1130",
        full_name: "Morgan Barn",
        start_date: Date.new(2013,12,1),
        end_date: Date.new(2015,3,1)
      )
  end

  def clear_tables
    ActiveRecord::Base.connection.execute(
      'TRUNCATE invoices, kids, families CASCADE'
    )
  end
end
