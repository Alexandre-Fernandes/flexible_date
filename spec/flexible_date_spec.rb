require File.join(File.dirname(__FILE__), 'spec_helper')

class Event < ActiveRecord::Base
  flexible_date :start_date, :end_date, :format => "%d/%m/%Y"
  flexible_date :judgement_day, :format => '%d-%m-%Y', :suffix => 'yyz'
end

describe 'flexible date' do
  describe 'suffixes' do
    it '_flex by default' do
      event = Event.new
      event.should respond_to(:start_date_flex)
      event.should respond_to(:start_date_flex=)
      event.should respond_to(:end_date_flex)
      event.should respond_to(:end_date_flex=)
    end

    it 'can be customized' do
      event = Event.new
      event.should respond_to(:judgement_day_yyz)
      event.should respond_to(:judgement_day_yyz=)
    end
  end

  it 'converts formatted inputs to respective fields' do
    event = Event.new
    event.start_date_flex = "31/01/2011"
    event.judgement_day_yyz =  "28-02-2011"
    event.start_date.should == Date.new(2011, 01, 31)
    event.judgement_day.should == Date.new(2011, 02, 28)
  end

  it 'returns dates formatted as configured' do
    event = Event.new :start_date => '2011-01-31',
                      :end_date => Date.new(2011, 02, 28)
    event.start_date_flex.should == "31/01/2011"
    event.end_date_flex.should == "28/02/2011"
  end

  context 'for invalid dates' do
    it 'invalidates the model' do
      event = Event.new
      event.start_date_flex = "31/04/2010"
      event.should_not be_valid
      event.errors[:start_date_flex].should be_any
      event.errors[:start_date].should be_any
    end

    it 'assigns nil' do
      event = Event.new
      event.start_date_flex = '30/04/2010'
      event.start_date_flex = '31/04/2010'
      event.start_date_flex.should be_nil
    end
  end
end

