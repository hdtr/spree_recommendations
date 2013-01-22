class CreateRecommendationIdentificationTimestamps < ActiveRecord::Migration
  def change
      create_table :spree_recommendation_identification_timestamps do |t|
          t.datetime :value
          t.string :type
      end
  end
end
