Spree.user_class.instance_eval do
    has_many    :product_buy_counts, :class_name => "Recommendation::ProductBuyCount", :foreign_key => "user_id"

    def find_all_with_atleast_one_purchase
        query = <<-HERE
        select DISTINCT spree_users.* from spree_users RIGHT JOIN spree_product_buy_counts ON spree_users.id=spree_product_buy_counts.user_id;
        HERE
        find_by_sql(query)
    end
end

Spree.user_class.class_eval do
    def substitutions_since(last_capture_timestamp, substitution_kind)
        behaviors = UserBehavior.all_user_behavior_since(id, last_capture_timestamp)
        substitution_kind.identify_substitutions(behaviors)
    end

    def common_products(user)
        user1_pbc = product_buy_counts()
        user2_pbc = user.product_buy_counts()
        user1_product_ids = user1_pbc.collect {|pbc| pbc.product_id}
        user2_product_ids = user2_pbc.collect {|pbc| pbc.product_id}
        user1_product_ids & user2_product_ids
    end

    def has_bought?(product_id)
        Recommendation::ProductBuyCount.count(:conditions => "user_id = #{self.id} AND product_id = #{product_id}") > 0
    end

    def is_loyal?
        orders.count(:conditions  => ["state=? and completed_at IS NOT NULL","complete"]) > 1
    end
end
