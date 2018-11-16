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
    var id: Int? = nil
    var name: String? = nil
    var image_url: String? = nil
    var tagline: String? = nil
    var first_brewed: String? = nil
    var desciption: String? = nil
    var abv: Double? = nil
    var ibu: Double? = nil
    var target_fg: Double? = nil
    var target_og: Double? = nil
    var ebc: Double? = nil
    var srm: Double? = nil
    var ph: Double? = nil
    var attenuation_level: Double? = nil
    var volume: Volume = Volume()
    var boil_volume: BoilVolume = BoilVolume()
    var ingredients: Ingredients = Ingredients()
    var food_pairing = [String]()
    var brewers_tips: String? = nil
    var contributed_by: String? = nil
    
    static func parseToBeerVO(_ data: JSON) -> Beer {
        let beer = Beer()
        beer.id = data["id"].int
        beer.name = data["name"].string
        beer.tagline = data["tagline"].string
        beer.first_brewed = data["first_brewed"].string
        beer.desciption = data["description"].string
        beer.image_url = data["image_url"].string
        beer.abv = data["abv"].double
        beer.ibu = data["ibu"].double
        beer.target_fg = data["target_fu"].double
        beer.target_og = data["target_og"].double
        beer.ebc = data["ebc"].double
        beer.srm = data["srm"].double
        beer.ph = data["ph"].double
        beer.attenuation_level = data["attenuation_level"].double
        beer.volume = {
            let vol = Volume()
            data["volume"].forEach{
                vol.unit = $0.1["unit"].string
                vol.value = $0.1["value"].int64
            }
            return vol
        }()
        
        beer.boil_volume = {
            let vol = BoilVolume()
            data["volume"].forEach{
                vol.unit = $0.1["unit"].string
                vol.value = $0.1["value"].int64
            }
            return vol
        }()
        
        
        
        var malts : [Malt] = []
        var hops : [Hop] = []
        
        data["ingredients"]["malt"].forEach {
            let malt = Malt()
            malt.name = $0.1["name"].string
            let amt = Amount()
            amt.value =  $0.1["amount"]["value"].int64
            amt.unit =  $0.1["amount"]["unit"].string
            malt.amount = amt
            malts.append(malt)
        }
        
        data["ingredients"]["hops"].forEach {
            let hop = Hop()
            hop.name = $0.1["name"].string
            let amt = Amount()
            amt.value =  $0.1["amount"]["value"].int64
            amt.unit =  $0.1["amount"]["unit"].string
            hop.amount = amt
            hop.add = $0.1["add"].string
            hop.attribute = $0.1["attribute"].string
            hops.append(hop)
        }
          
        beer.ingredients.hops = hops
        beer.ingredients.malt = malts
        beer.ingredients.yeast = data["ingredients"]["yeast"].string
        beer.food_pairing = data["food_pairing"].arrayValue.map {$0.stringValue}
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

