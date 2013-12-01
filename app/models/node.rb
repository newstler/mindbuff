class Node
	include Mongoid::Document
	include Mongoid::Timestamps
	include Mongoid::TagsArentHard

	include AutoHtmlFor

	has_and_belongs_to_many :nodes, class_name: "Node", inverse_of: :nodes, autosave: true

	field :link

	validates :link, presence: true

	taggable_with :tags

	auto_html_for :link do
		html_escape
		image
		youtube
		vimeo
		google_map width: 600, height: 550
		soundcloud
		twitter
		instagram
		flickr

		redcarpet renderer: Redcarpet::Render::HTML.new(hard_wrap: false, filter_html: false, safe_links_only: true, with_toc_data: true), markdown_options: {        
			autolink: false,
			no_intra_emphasis: true,
			strikethrough: true,
			lax_spacing: true,
			space_after_headers: true,
			underline: true,
			highlight: true,
			quote: true,
			footnotes: true,
			tables: true
		}

		link target: "_blank", rel: "nofollow"
	end

	def self.search_instagram(max_id = nil)
		tag = 'iOSonRailsConf'

		unless max_id
			page = Instagram.tag_recent_media(tag)
		else
			page = Instagram.tag_recent_media(tag, max_id: max_id)
		end
		
		page.each do |item|
			unless where(image_id: item.id).any?
				create!(
					image_id: item.id,
					image: item.images.low_resolution.url,
					likes_count: item.likes.count,
					link_url: item.link
				)
			end
		end

		Node.search_instagram(page.pagination.next_max_id) if page.pagination.next_max_id
	end

	def image
		Nokogiri::HTML(link_html).css('img').map{ |i| i['src'] }.first
	end

	def node_for_json
    {
      id: _id.to_s,
      # link: link,
      image: image,
      # tags: tags,
      connections: Node.with_any_tags(tags).collect { |n| {id: n._id.to_s} unless n == self }.compact  # connected_to_ids.collect{ |contact| c = Attendee.find(contact); {id: c._id, slug: c.slug, name: c.name, avatar: c.avatar} },
    }
  end
end
