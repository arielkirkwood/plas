class Ticket < ActiveRecord::Base
  belongs_to :event
  has_one :generates_ticket, :class_name => "Ticket"
  has_many :registrations

  validates_numericality_of :price, :greater_than => 0, :presence => true
  validates_numericality_of :available, :greater_than => 0, :presence => true
  validates_numericality_of :generates_number, :greater_than => 0, :allow_blank => true
  #TODO: more validations
  #
#TODO: refactor to use Money instead of just having cents in price
  composed_of :price,
    :class_name => "Money",
    :mapping => [%w(cents cents), %w(currency currency_as_string)],
    :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) }

#  composed_of :prix,
#    :class_name => "Money",
#    :mapping => [%w(price cents)],
#    :constructor => Proc.new { |price| Money.new(price || 0, Money.default_currency) }

  def sold_out?
    registrations.count >= available
  end

  def within_sales_period?
    now = Time.now
    date_open < now and now < date_closed
  end

  def remaining
    available - registrations.count
  end

  def available?
    not sold_out? and within_sales_period?
  end
end
