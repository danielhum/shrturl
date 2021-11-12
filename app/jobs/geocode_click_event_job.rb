class GeocodeClickEventJob < ApplicationJob
  queue_as :default

  def perform(*args)
    id = args[0]
    click = ClickEvent.find(id)
    click.geocode
    click.save
  end
end
