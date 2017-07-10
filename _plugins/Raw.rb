module Jekyll

    class RawContent < Generator

        def generate(site)
            site.posts.each do |post|
                post.data['raw'] = post.content
            end
        end

    end

end
