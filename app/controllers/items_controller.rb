class ItemsController < ApplicationController
  def item
    @offer = Offer.find(allowed_params.to_i)
    @pictures = if valid_json?(@offer.picture)
                  JSON.parse(@offer.picture)
                else
                  [@offer.picture]
                end
  end

  private

  def allowed_params
    params.require(:id)
  end

  def valid_json?(json)
    JSON.parse(json)
    return true
  rescue JSON::ParserError => e
    return false
  end
end
