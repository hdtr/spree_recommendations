Spree::Taxon.instance_eval do
    has_one :taxon_configuration, :class_name => "Spree::TaxonConfiguration", :foreign_key => "taxon_id"
end

Spree::Taxon.class_eval do

    def substitutions_enabled?
        !taxon_configuration.nil? && taxon_configuration.recommendation_type == "sub"
    end

    def recommendations_enabled?
        !taxon_configuration.nil? && taxon_configuration.recommendation_type == "rec"
    end
end
