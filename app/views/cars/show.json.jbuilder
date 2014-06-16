json._links do
  json.self do
    json.href car_path(@car)
  end
  json.make do
    json.href make_path(@car.make_id)
  end
end
json.id @car.id
json.color @car.color
json.purchased_on @car.purchased_on
