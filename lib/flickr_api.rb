class FlickrApi
  require 'flickraw'
  
  #photo by english tags
  #for normal size - remove _s in end of file
  ##TODO?: can take second argument cluster_id as "banana/orange/apple" - three tags
  def self.photos_by_tag tag
  	FlickrApi.initialize_api_key
    list = flickr.tags.getClusterPhotos(:tag => tag)
    list.map{|el| "http://farm#{el.farm}.staticflickr.com/#{el.server}/#{el.id}_#{el.secret}_s.jpg"}
  end

  #related tags for any english word
  def self.related_tags tag
  	FlickrApi.initialize_api_key
    flickr.tags.getRelated(:tag=>tag)
  end

  #tags for photo by its static url
  def self.tags_by_static_url url
  	FlickrApi.initialize_api_key
    photo_id = /\/(\d+)_/.match(url)[1]
    all_tags = flickr.tags.getListPhoto(:photo_id=>photo_id)
    all_tags["tags"].map{|el| el._content}
  end

  def self.initialize_api_key
  	FlickRaw.api_key="a5649ddf7d25dd8d14eb2092ef7e8116"
    FlickRaw.shared_secret="ca8f2f496226036d"
  end
end