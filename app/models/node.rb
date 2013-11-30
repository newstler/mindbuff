class Node
	include Mongoid::Document
	include Mongoid::Timestamps

	include AutoHtmlFor

	field :link

	validates :link, presence: true

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
end
