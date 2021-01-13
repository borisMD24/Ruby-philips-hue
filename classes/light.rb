class Light
    def initialize(nbr, url, name)
        @url = url + nbr.to_s + "/";
        @name = name
    end
    def setState(body)
        url = @url + "state"
        response = HTTParty.put(url,  
                         :body => body)
    end
    def name
        @name
    end
    
end