# StockLevel Documentation
#
# The stock_level table records any stock adjustments made to a SKU.
# Whether by a successful order or an adjustment in the administration control panel.

# == Schema Information
#
# Table name: stock_levels
#
#  id                   :integer            not null, primary key
#  description          :string(255)        
#  adjustment           :integer            default(0)
#  sku_id               :integer            
#  created_at           :datetime           not null
#  updated_at           :datetime           not null
#
class StockLevel < ActiveRecord::Base

  attr_accessible :adjustment, :description, :sku_id

  belongs_to :sku

  validates :description, :adjustment,                      :presence => true
  validate :adjustment_value

  before_save :stock_level_adjustment

  default_scope order('created_at DESC')

  # Modify the sku stock with the associated stock level adjustment value
  #
  def stock_level_adjustment
    if Store::positive?(self.adjustment)
      self.sku.update_column(:stock, self.sku.stock + self.adjustment)
    else
      self.sku.update_column(:stock, self.sku.stock - self.adjustment.abs)
    end
  end

  # Validation to check whether the adjustment value is above or below zero
  #
  # @return [Boolean]
  def adjustment_value
    if self.adjustment == 0
      errors.add(:adjustment, "must be greater or less than zero.")
      return false
    end
  end

end
