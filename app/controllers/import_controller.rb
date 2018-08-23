class ImportController < ApplicationController
  def imports

  end

  def import
    ImportFromSources.instance.import_from_sources
  end
end
