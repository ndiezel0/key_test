class HomeController < ApplicationController
  def index
    @found_items = if allowed_params[:search_offers]
                     search_offer(allowed_params[:search_offers])
                   else
                     []
                   end
  end

  def search
    redirect_to controller: :home, action: :index, search_offers: allowed_params[:search][:search]
  end

  private

  def search_offer(srch)
    replacements = {
      ' ' => ' & '
    }
    # TODO add ranking functionality to search
    result = ActiveRecord::Base.connection.exec_query("
    SELECT result
                FROM (SELECT offers.id as result,
                  ( to_tsvector(format('%s %s %s %s %s %s %s',
                                        offers.name,
                                        offers.type_prefix,
                                        offers.vendor,
                                        offers.model,
                                        offers.description,
                                        coalesce(string_agg(extra_infos.name, ' ')),
                                        coalesce(string_agg(categories.name, ' '))
                  )))  as document
          FROM offers
          LEFT OUTER JOIN extra_infos ON extra_infos.offer_id = offers.id
          LEFT OUTER JOIN categories_offers ON categories_offers.offer_id = offers.id
          LEFT OUTER JOIN categories ON categories.id = categories_offers.category_id
          GROUP BY offers.id) o_search
    WHERE o_search.document @@ to_tsquery('#{srch.gsub(Regexp.union(replacements.keys), replacements)}')
  ")
    result = result.rows.map { |i| i[0] }
    result = Offer.find(result)
    result
  end

  def allowed_params
    params.permit(:search_offers, search: [:search])
  end
end
