defmodule HenryTest.RSS do
  use ExUnit.Case
  doctest Henry.RSS

  test "item renders an item" do
    date = DateTime.utc_now()

    item = %Henry.RSS.Item{
      title: 'My radical post',
      desc: 'this is such a cool post',
      publish_date: date,
      link: 'http://www.my-site.com/posts/my-radical-post',
      guid: 'http://www.my-site.com/posts/my-radical-post'
    }

    actual = Henry.RSS.item(item)
    expected = """
    <item>
      <title>#{item.title}</title>
      <description><![CDATA[#{item.desc}]]></description>
      <pubDate>#{item.publish_date}</pubDate>
      <link>#{item.link}</link>
      <guid>#{item.guid}</guid>
    </item>
    """

    assert actual == expected
  end
end
