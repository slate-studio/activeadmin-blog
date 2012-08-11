xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Blog title goes here"
    xml.description "Blog description goes here"
    xml.link blog_url

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.excerpt
        xml.pubDate post.date.to_s(:rfc822)
        xml.link blog_post_url(post)
        xml.guid blog_post_url(post)
      end
    end
  end
end
