Spree::ProductsController.class_eval do

  def show
    return unless @product

    @variants = Spree::Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = Spree::ProductProperty.includes(:property).where(:product_id => @product.id)

    referer = request.env['HTTP_REFERER']
    if referer
      referer_path = URI.parse(request.env['HTTP_REFERER']).path
      if referer_path && referer_path.match(/\/t\/(.*)/)
        @taxon = Spree::Taxon.find_by_permalink($1)
      end
    end
    if @product.substitutions_enabled?
        @substitutes = @product.substitutes
        p "#############\n############\n substitutes #{@substitutes.inspect}\n\n"
        if !@substitutes.empty? && @substitutes.first.is_promotional?
            @promotion = @substitutes.first
            @substitutes.shift
        end 
        p "#############\n############\n promotions #{@promotion.inspect}"
    elsif @product.recommendations_enabled?
        @similar_products = @product.similar_products
    end

    @recommendations_available = (!@substitutes.empty? or @promotion)
    p "#############\n############\n recommendation #{@recommendations_available}"
    @cf_recommendations = Recommendation::CFRecommendation.for_user(spree_current_user) unless spree_current_user.nil?
    respond_with(@product)
  end

  private

  def current_user_is_loyal?
    !spree_current_user.nil? && spree_current_user.is_loyal?
  end
end

