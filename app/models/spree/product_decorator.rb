Spree::Product.class_eval do
    CATEGORIES_TAXONOMY_NAME = "Categories"
    BRAND_TAXONOMY_NAME = "Brand"

    attr_accessor :is_promotional

    def is_promotional?
        !!@is_promotional
    end


    def out_of_stock?
        variants.empty? ? count_on_hand == 0 : variants.all?{|v| v.count_on_hand == 0}
    end

    def category_taxon
        taxons.select {|t| t.taxonomy.name == CATEGORIES_TAXONOMY_NAME}
    end

    def brand_taxon
        taxons.select {|t| t.taxonomy.name == BRAND_TAXONOMY_NAME}.first
    end

    def least_priced_variant
        variants.sort {|x, y| x.price <=> y.price}.first
    end

    def substitutes
        out_of_stock? ? OOSSubstitutionProbability.find_substitutes_for(self) : UpsellProbability.find_upsells_for(self)
    end

    def substitutions_enabled?
        !taxons.empty? && taxons.any? {|t| t.substitutions_enabled?}
    end

    def recommendations_enabled?
        !taxons.empty? && taxons.any? {|t| t.recommendations_enabled?}
    end
end
