class CreateSpreeTaxonConfiguration < ActiveRecord::Migration
    def change
        create_table "spree_taxon_configurations" do |t|
            t.integer :taxon_id
            t.string :recommendation_type
        end
    end
end
