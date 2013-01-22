class InsertProbabilityThresholdForDiscountIntoPreferences < ActiveRecord::Migration
  def change
      Spree::Preference.create(:key => "spree/app_configuration/probability_threshold_for_discounts", :value => 0.3, :value_type => "decimal")
  end
end
