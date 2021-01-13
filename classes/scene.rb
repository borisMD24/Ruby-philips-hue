class Scene
    def initialize(url)
        @queue = []
        @url = url
        self.setLights
    end
    def setState(body)
        url = @url + "state"
        response = HTTParty.put(url, :body => body)
    end 
    def setLights
    response = HTTParty.get(@url)
    obj = JSON.parse(response.body)
    h = obj.length
    while h > 0 
        @queue.push(Light.new(h, @url, obj[h.to_s]["name"]))
        h -= 1
    end
    end
    def RGBtoXYZ(red, green, blue)
        if(red > 0.04045)
            red = ((red + 0.055) / (1.0 + 0.055) ** 2.4)
        else
            red = red / 12.92
        end
        if(green > 0.04045)
            green = ((green + 0.055) / (1.0 + 0.055) ** 2.4)
        else
            green = green / 12.92
        end
        if(blue > 0.04045)
            blue = ((blue + 0.055) / (1.0 + 0.055) ** 2.4)
        else
            blue = blue / 12.92
        end
        x = red * 0.664511 + green * 0.154324 + blue * 0.162028;
        y = red * 0.283881 + green * 0.668433 + blue * 0.047685;
        z = red * 0.000088 + green * 0.072310 + blue * 0.986039;
        rx = (x / (x + y + z)).round(4);
        ry = (y / (x + y + z)).round(4);
        return "\"xy\":[#{rx},#{ry}],"
    end
    def bri(perc)
        perc = perc * 255 / 100
        if(perc > 254)
            perc = 254
        end
        if perc < 1
            perc = 1
        end
        return "\"bri\":#{perc},"
    end
    def setAllLights(body)
        @queue.map{|l| l.setState(body)}
    end
    def setStateByName(name, body)
        light = @queue.select { |light| light.name == name }
        light[0].setState(body)
    end
    def interpretor(json)
        if(json.class != Hash)
            json = JSON.parse(json)
        end
        instructions = []
        keys = json.keys
        keys.map do |key|
            instructions.push(json[key])
        end
        self.execute(instructions);
    end
    def asyncConverstion(h)
        return h[h.keys[0]]
    end
    def execute(h)
        h.map do |instruction|
            body = "{"
            if instruction.key?("color")
                if instruction["color"]["type"] == "rgb"
                    rgb = instruction["color"]["value"]
                    body += RGBtoXYZ(rgb[0], rgb[1], rgb[2])
                end
            end
            if instruction.key?("bri")
                body += bri(instruction["bri"])
            end
            if instruction.key?("trt")
                body += "\"transitiontime\" : #{instruction["trt"]},"
            end
            body = body.chop
            body += "}"
            p body
            if instruction.key?("light")
                if(instruction["light"] == "all")
                    self.setAllLights(body)
                else
                    p instruction["light"]
                    self.setStateByName(instruction["light"], body)
                end
            end
            if instruction.key?("timeout")
                sleep(instruction["timeout"]/10)
            end
        end
    end
end
