//
//  Beer.swift
//  Beers
//
//  Created by Sargon Zi on 11/13/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit
import SwiftyJSON

class Beer {
    var id: String? = nil
    var name: String? = nil
    var image_url: String? = nil
    var tagline: String? = nil
    var first_brewed: String? = nil
    var desciption: String? = nil
    var adv: Double? = nil
    var ibu: Double? = nil
    var target_fg: Double? = nil
    var target_og: Double? = nil
    var ebc: Double? = nil
    var srm: Double? = nil
    var ph: Double? = nil
    var attenuation_level: Double? = nil
    var volume: Volume? = nil
    var boil_volume: BoilVolume? = nil
    var ingredients: Ingredients? = nil
    var food_pairing: [String]? = nil
    var brewers_tips: String? = nil
    var contributed_by: String? = nil
    
    static func parseToBeerVO(_ data: JSON) -> Beer {
        let beer = Beer()
        beer.id = data["id"].string
        beer.name = data["name"].string
        beer.tagline = data["tagline"].string
        beer.first_brewed = data["first_brewed"].string
        beer.desciption = data["description"].string
        beer.image_url = data["image_url"].string
        beer.adv = data["adv"].double
        beer.ibu = data["ibu"].double
        beer.target_fg = data["target_fu"].double
        beer.target_og = data["target_og"].double
        beer.ebc = data["ebc"].double
        beer.srm = data["srm"].double
        beer.ph = data["ph"].double
        beer.attenuation_level = data["attenuation_level"].double
//        beer.volume = data["volume"] as Volume
//        beer.boil_volume = data["boil_volume"] as BoilVolume
//        beer.ingredients = data["ingredients"] as Ingredients
//        beer.food_pairing = data["foot_paring"] as [String]
        beer.brewers_tips = data["brewers_tips"].string
        beer.contributed_by = data["contributed_by"].string
        
        return beer
    }
}

class BaseVolume {
    var value: Int64? = nil
    var unit: String? = nil
}

class Volume : BaseVolume {
   
}

class BoilVolume: BaseVolume {
    
}

class Amount: BaseVolume {

}

class Ingredients {
    var malt: [Malt]? = nil
    var hops: [Hop]? = nil
    var yeast: String? = nil
}

class Malt {
    var name: String? = nil
    var amount: Amount? = nil
}


class Hop {
    var name: String? = nil
    var amount: Amount? = nil
    var add: String? = nil
    var attribute: String? = nil
}
