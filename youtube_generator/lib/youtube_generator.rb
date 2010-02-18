module ActionView
  class Base
    def generate_youtube(video_code, options = {:width=>"150px",:height=>"150px"})
      width = options[:width]
      height = options[:height]
      video = get_video_id(video_code)
      html = ""
      html += "<object width=\""+width+"px\" height=\""+height+"px\"><param name=\"movie\" value=\"http://www.youtube.com/v/#{video}&hl=en\"></param><param name=\"allowFullScreen\" value=\"true\"></param><embed src=\"http://www.youtube.com/v/#{video}&hl=en\" type=\"application/x-shockwave-flash\"  allowfullscreen=\"true\"  width=\""+width+"px\" height=\""+height+"px\"></embed></object>"
      return html
    end

    private

    def get_video_id(video_code)
      unless video_code.nil?
        # Check whether Youtube embed code was entered
        doc = Hpricot.parse(video_code)
        #Check if there is a movie param
        embed_url = if (element = doc % "//param[@name='movie']")
          element.attributes["value"]
        elsif element = doc % "//embed" #Check for the movie code in the embed element
          element.attributes["src"]
        end

        #If we have pulled out a URL from the embed code, get the v param
        if embed_url && (match = %r{/v/(\w+)&}.match(embed_url))
          return match[1]
        end

        #If the user entered the video page url
        query_string = video_code.split( '?', 2)[1]
        if query_string
          params = CGI.parse(query_string)
          if params.has_key?("v")
            return params["v"][0]
          end
        end
      end
    end
  end
end