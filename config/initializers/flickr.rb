class FlickrApi
  require 'flickraw'
  require 'open-uri'
  
  #photo by english tags
  #for normal size - remove _s in end of file
  ##TODO?: can take second argument cluster_id as "banana/orange/apple" - three tags
  def self.photos_by_tag tag
    FlickrApi.initialize_api_key
    list = flickr.tags.getClusterPhotos(:tag => tag).to_a[0..6]
    list.collect {|el| { image: "http://farm#{el.farm}.staticflickr.com/#{el.server}/#{el.id}_#{el.secret}_m.jpg", tags: get_tags(el.id)} }
  end

  def self.photos_by_tags tags
    FlickrApi.initialize_api_key
    tags.each do |tag|
      photos_by_tag tag
    end
  end

  def self.get_info photo_id
    FlickrApi.initialize_api_key
    flickr.photos.getInfo photo_id
  end

  def self.get_tags photo_id
    FlickrApi.initialize_api_key
    # list = flickr.tags.getListPhoto(:photo => photo_id)
    url = "http://api.flickr.com/services/rest/?method=flickr.tags.getListPhoto&api_key=e7be9c2cd144c438edf232b236f4a256&photo_id=#{photo_id}&format=json&nojsoncallback=1"
    tags = JSON.parse(open(url).read)
    tags["photo"]["tags"]["tag"].collect { |tag| tag["raw"] } if tags
  end

  #related tags for any english word
  def self.related_tags tag
  	FlickrApi.initialize_api_key
    flickr.tags.getRelated(:tag=>tag)
  end

  #tags for photo by its static url
  def self.tags_by_static_url url
  	FlickrApi.initialize_api_key
    photo_id = get_photo_id_from_url url
    all_tags = flickr.tags.getListPhoto(:photo_id=>photo_id)
    all_tags["tags"].map{|el| el._content}
  end

  def self.initialize_api_key
  	FlickRaw.api_key="a5649ddf7d25dd8d14eb2092ef7e8116"
    FlickRaw.shared_secret="ca8f2f496226036d"
  end

  def self.get_photo_id_from_url url
    url.split("/photos/")[1].split("/")[1]
  end
end