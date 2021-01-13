require 'httparty'
require 'json'
require_relative './classes/light.rb'
require_relative './classes/scene.rb'

URL = "http://192.168.1.10/api/cRW0Q2-jcTc5Pv9c6igLR6hfph7CFSFxFhf6oQbo/lights/"


s = Scene.new(URL)


s.interpretor('{
    "1" : {
        "light" : "plafonier",
        "color" : {
            "type" : "rgb",
            "value" : [0, 255, 0]
        },
        "bri":100,
        "trt" : 10,
        "timeout" : 20
    },
    "2" : {
        "light" : "lampe",
        "color" : {
            "type" : "rgb",
            "value" : [255, 0, 0]
        },
        "bri":100,
        "trt" : 10,
        "timeout" : 40
    },
    "3" : {
        "light" : "all",
        "color" : {
            "type" : "rgb",
            "value" : [0, 0, 255]
        },
        "bri":100,
        "trt" : 10,
        "timeout" : 20
    },
    "4" : {
        "light" : "all",
        "color" : {
            "type" : "rgb",
            "value" : [230, 25, 102]
        },
        "bri" : 20,
        "trt" : 20
    }
  }')

    puts s.bri(100);