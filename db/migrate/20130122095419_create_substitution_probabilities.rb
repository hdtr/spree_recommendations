class CreateSubstitutionProbabilities < ActiveRecord::Migration
  def change
    create_table :spree_substitution_probabilities, :force => true do |t|
      t.integer   :searched_product
      t.integer   :bought_product
      t.float    :probability
      t.string    :type
      t.timestamps
    end
  end
end
