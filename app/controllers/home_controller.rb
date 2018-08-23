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
    prepared_search = srch.gsub(Regexp.union(replacements.keys), replacements)
    result = ActiveRecord::Base.connection.exec_query("
    SELECT result
                FROM (SELECT offers.id as result,
                  setweight(to_tsvector(format('%s', offers.name)),                                         'A') ||
                  setweight(to_tsvector(format('%s', offers.type_prefix)),                                  'B') ||
                  setweight(to_tsvector(format('%s', offers.vendor)),                                       'B') ||
                  setweight(to_tsvector(format('%s', offers.model)),                                        'B') ||
                  setweight(to_tsvector(format('%s', offers.description)),                                  'D') ||
                  setweight(to_tsvector(format('%s', coalesce(string_agg(extra_infos.name, ' ')))),         'D') ||
                  setweight(to_tsvector(format('%s', coalesce(string_agg(categories.name, ' ')))),          'C')  as document
          FROM offers
          LEFT OUTER JOIN extra_infos ON extra_infos.offer_id = offers.id
          LEFT OUTER JOIN categories_offers ON categories_offers.offer_id = offers.id
          LEFT OUTER JOIN categories ON categories.id = categories_offers.category_id
          GROUP BY offers.id) o_search
    WHERE o_search.document @@ to_tsquery('#{prepared_search}')
    ORDER BY ts_rank(o_search.document, to_tsquery('#{prepared_search}')) DESC;
  ")
    result = result.rows.map { |i| i[0] }
    result = Offer.find(result)
    result
  end

  def allowed_params
    params.permit(:search_offers, search: [:search])
  end
end
