xml.apiResponse {
  xml.links {
    xml.self('href' => make_path(@make))
  }
  xml.make {
    xml.id(@make.id)
    xml.name(@make.name)
  }
}