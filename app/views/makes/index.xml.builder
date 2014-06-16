xml.apiResponse {
  xml.links {
    xml.self("href" => "/makes")
  }
  xml.makes {
    @makes.each do |make|
      xml.make {
        xml.links {
          xml.self("href" => "/makes/#{make.id}")
        }
        xml.id(make.id)
        xml.name(make.name)
      }
    end
  }
}