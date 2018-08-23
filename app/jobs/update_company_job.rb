require 'sneakers'

class UpdateCompanyJob
  include Sneakers::Worker
  from_queue 'update_company_queue'

  def work(msg)
    # puts 'update company ' + msg
    puts msg + ' ' + ((Time.now.to_f * 1000.0).to_i).to_s
    msg = msg.to_i
    source = Source.where(id: msg).first
    if source
      response = HTTParty.get(source.url,
                   headers: {
                     'Content-Type': 'text/yaml'
                   })
      object = response.parsed_response
      # byebug
      if object
        update_company(source, object['yml_catalog']['shop'])
      else
        puts 'Something wrong with object'
        puts response.response
      end
    else
      puts 'No source was found with id: ' + msg
    end
    ack!
  end

  private

  def update_company(source, object)
    company = source.company
    unless company
      company = Company.new
      company.source = source
    end
    company.name =                    object['name'] if object['name']
    company.company_name =            object['company'] if object['company']
    company.url =                     object['url'] if object['url']
    company.local_delivery_cost =     object['local_delivery_cost'] if object['local_delivery_cost']
    # byebug
    company.save!
    # byebug
    object['categories']['category'].each do |category|
      update_category(company, category)
    end
    object['offers']['offer'].each_slice(25) do |offers|
      msg = {
        id: company.id,
        offers: offers
      }
      ImportFromSources.instance.update_offers(msg.to_json)
    end
    puts company.name + ' ended updating'
  end

  def update_category(company, object)
    category_id = object['id'].to_i
    category = company.categories.where(cat_id: category_id).first
    unless category
      category = Category.new
      category.cat_id = category_id
      category.company = company
    end
    if object['parentId']
      # Could probably skip this search if saved parent category id in object too
      parent_id = object['parentId'].to_i
      category.parent = company.categories.where(cat_id: parent_id).first
    end

    category.name = object['__content__'] if object['__content__']
    category.save
    # byebug
  end

  def update_offer(company, object)
    offer_id = object['id'].to_i
    offer = company.offers.where(off_id: offer_id).first
    unless offer
      offer = Offer.new
      offer.company = company
      offer.off_id = offer_id
    end
    offer.group_id =              object['group_id'].to_i if object['group_id']
    offer.ctype =                 object['type'].to_i if object['type']
    offer.available =             to_bool(object['available']) if object['available']

    offer.url =                   object['url'] if object['url']
    offer.price =                 object['price'].to_i if object['price']
    offer.base_price =            object['baseprice'].to_i if object['baseprice']
    # TODO Currrency
    offer.picture =               object['picture'] if object['picture']
    offer.age =                   object['age'] if object['age']
    offer.barcode =               object['barcode'] if object['barcode']
    offer.name =                  object['name'] if object['name']
    offer.type_prefix =           object['typePrefix'] if object['typePrefix']
    offer.vendor =                object['vendor'] if object['vendor']
    offer.model =                 object['model'] if object['model']
    offer.description =           object['description'] if object['description']
    offer.sales_notes =           object['sales_notes'] if object['sales_notes']

    offer.store =                 to_bool(object['store']) if object['store']
    offer.pickup =                to_bool(object['pickup']) if object['pickup']
    offer.delivery =              to_bool(object['delivery']) if object['delivery']
    offer.ordering_time =         object['orderingTime']['ordering'] if object['orderingTime'] && object['orderingTime']['ordering']
    offer.manufacturer_warranty = object['manufacturer_warranty'] if object['manufacturer_warranty']
    offer.local_delivery_cost =   object['local_delivery_cost'] if object['local_delivery_cost']

    offer.save
    if object['param']
      object['param'].each do |param|
        update_extra_info(offer, param)
      end
    end
  end

  def update_extra_info(offer, object)
    key = object['name']
    extra_info = offer.extra_infos.where(name: key).first
    unless extra_info
      extra_info = ExtraInfo.new
      extra_info.offer = offer
      extra_info.name = key
    end
    extra_info.value = object['__content__'] if object['__content__']
    extra_info.save
  end

  def to_bool(str)
    ActiveModel::Type::Boolean.new.cast(str)
  end
end
