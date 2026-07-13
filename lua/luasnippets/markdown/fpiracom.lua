local function current_date()
  return os.date('%Y-%m-%d')
end

return {
  s({ trig = 'frontmatter', name = 'fpiracom frontmatter', dscr = 'Create fpiracom post frontmatter' }, {
    t({ '---', 'date: ' }), f(current_date),
    t({ '', 'title: "' }), i(1, 'Post title'), t('"'),
    t({ '', 'subtitle: "' }), i(2, 'Post subtitle'), t('"'),
    t({ '', 'description: "' }), i(3, 'Post description'), t('"'),
    t({ '', '"categories": [' }), i(4, '"category"'), t(']'),
    t({ '', '"tags": [' }), i(5, '"tag"'), t(']'),
    t({ '', 'seoimage: "' }), i(6, '300x/image.jpg'), t('"'),
    t({ '', '---', '' }), i(0),
  }),

  s({ trig = 'postimage', name = 'fpiracom Markdown image', dscr = 'Insert a post image using site.baseurl' }, {
    t('!['), i(1, 'image description'),
    t(']({{ site.baseurl }}/static/postimages/'), i(2, '300x/image.jpg'), t(')'),
    i(0),
  }),

  s({ trig = 'imageinclude', name = 'fpiracom image include', dscr = 'Insert the fpiracom image.html include' }, {
    t({ '{% include image.html', 'url="/static/postimages/' }),
    i(1, 'YYYY-MM-DD'), t('/'), i(2, 'image'), t('.jpg"'),
    t({ '', 'desc="' }), i(3, 'Image description and attribution'), t('"'),
    t({ '', 'alt="' }), i(4, 'Image alt text'), t('"'),
    t({ '', 'link="<' }), i(5, 'https://example.com/article'), t('>"'),
    t({ '', 'credits="<' }), i(6, 'https://example.com/author'), t('>"'),
    t({ '', '%}' }), i(0),
  }),

  s({ trig = 'gist', name = 'fpiracom Gist', dscr = 'Embed a GitHub Gist' }, {
    t('{% gist '), i(1, 'gist_id'), t(' %}'), i(0),
  }),

  s({ trig = 'youtube', name = 'fpiracom YouTube', dscr = 'Embed a YouTube video' }, {
    t('{% youtube '), i(1, 'video_id'), t(' %}'), i(0),
  }),

  s({ trig = 'vimeo', name = 'fpiracom Vimeo', dscr = 'Embed a Vimeo video' }, {
    t('{% vimeo '), i(1, 'video_id'), t(' %}'), i(0),
  }),

  s({ trig = 'ted', name = 'fpiracom TED', dscr = 'Embed a TED video' }, {
    t('{% ted '), i(1, 'video_id'), t(' %}'), i(0),
  }),

  s({ trig = 'posturl', name = 'fpiracom post link', dscr = 'Link to another Jekyll post' }, {
    t('['), i(1, 'link text'), t(']({% post_url '),
    i(2, 'YYYY-MM-DD-post-slug'), t(' %})'), i(0),
  }),

  s({ trig = 'staticlink', name = 'fpiracom static link', dscr = 'Link to a static file using the Jekyll link tag' }, {
    t('{% link '), i(1, 'static/postfiles/path/file.ext'), t(' %}'), i(0),
  }),

  s({ trig = 'externallink', name = 'fpiracom external link', dscr = 'Link to site.data.external in a new tab' }, {
    t('['), i(1, 'link text'), t(']({{ site.data.external.'), i(2, 'key'),
    t(' }}){:target="_blank"}{:rel="noopener noreferrer"}'), i(0),
  }),
}
