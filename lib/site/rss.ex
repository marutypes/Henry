defmodule Henry.Site.RSS do
  alias Henry.Site
  alias Site.Page
  alias Site.Frontmatter
  alias Site.Config
  alias Site.RSS.Item
  alias Site.RSS.Channel

  def render_from_site(site) do
    site
    |> construct
    |> feed
  end

  def construct(site) do
    %Site{
      config: %Config{
        site_name: site_name,
        description: description,
        site_url: site_url,
        language: language
      },
      posts: posts
    } = site

    %Channel{
      title: site_name,
      link: site_url,
      desc: description,
      date: Timex.now |> Timex.format!("{RFC822}"),
      lang: language,
      items:
        Enum.map(posts, fn (post) ->
          %Page{
            frontmatter: %Frontmatter{
              title: post_title,
              summary: post_desc,
              date: date,
              slug: slug,
            }
          } = post

          link = Path.join(site_url, slug)

          %Item{
            title: post_title,
            desc: post_desc,
            publish_date: date,
            link: link,
            guid: link
          }
        end)
    }
  end

  def feed(data) do
    """
    <?xml version="1.0" encoding="utf-8"?>
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
      #{channel(data)}
    </rss>
    """
  end

  def item(data) do
    %Item{
      title: title,
      desc: desc,
      publish_date: publish_date,
      link: link,
      guid: guid
    } = data

    """
    <item>
      <title>#{title}</title>
      <description><![CDATA[#{desc}]]></description>
      <pubDate>#{publish_date}</pubDate>
      <link>#{link}</link>
      <guid>#{guid}</guid>
    </item>
    """
  end

  def channel(data) do
    %Channel{
      title: title,
      link: link,
      desc: desc,
      date: date,
      lang: lang,
      items: items
    } = data

    """
      <channel>
        <title>#{title}</title>
        <link>#{link}</link>
        <description>#{desc}</description>
        <lastBuildDate>#{date}</lastBuildDate>
        <language>#{lang}</language>
        <atom:link href="#{link}/rss.xml" rel="self" type="application/rss+xml" />
        #{Enum.map(items, &item/1)}
      </channel>
    """
  end
end
