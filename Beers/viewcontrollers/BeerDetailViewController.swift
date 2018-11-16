//
//  BeerDetailViewController.swift
//  Beers
//
//  Created by Sargon Zi on 11/13/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class BeerDetailViewController: UIViewController {
    
    @IBOutlet weak var ivBeer: UIImageView!
    @IBOutlet weak var lblBeerTitle: UILabel!
    @IBOutlet weak var lblAlcohol: UILabel!
    @IBOutlet weak var lblIBU: UILabel!
    @IBOutlet weak var lblYeast: UILabel!
    @IBOutlet weak var lblFirstBrew: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblFoodParing: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblFinalVolume: UILabel!
    @IBOutlet weak var lblBoilVolume: UILabel!
    @IBOutlet weak var lblTargetOF: UILabel!
    @IBOutlet weak var lblTargetFG: UILabel!
    @IBOutlet weak var lblSRM: UILabel!
    @IBOutlet weak var lblPh: UILabel!
    @IBOutlet weak var lblAttenu: UILabel!
    @IBOutlet weak var lblMalts: UILabel!
    @IBOutlet weak var lblHops: UILabel!
    @IBOutlet weak var lblBreTips: UILabel!
    @IBOutlet weak var lblContribute: UILabel!
    
    
    var beer: Beer!
    var beerId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBeerDetailById(id: beerId)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showBeerImageView))
        self.ivBeer.isUserInteractionEnabled = true
        self.ivBeer.addGestureRecognizer(gesture)
    }
    
    
    @objc func showBeerImageView(_ sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    //Call beer detail api by id
    func loadBeerDetailById(id:Int){
        Alamofire.request("https://api.punkapi.com/v2/beers/\(id)", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                let api = response.result.value
                let json = JSON(api!)
                let data = json.array
                if let result = data {
                    result.forEach({ (beer) in
                        self.beer = Beer.parseToBeerVO(beer)
                    })
                }
                self.bindBeerDetail(beer: self.beer)
                break
                
            case .failure:
                print("Fail to call api")
                break
            }
        }
    }
    
    private func bindBeerDetail(beer: Beer) {
        ivBeer.sd_setImage(with: URL(string: beer.image_url!), placeholderImage: UIImage(named: "bottle"))
        lblBeerTitle.text = beer.name
        lblAlcohol.text = NSString(format: "Alcohol: %.1f", beer.abv ?? 0.0) as String
        lblIBU.text = "IBU: \(beer.ibu ?? 0)"
        lblYeast.text = "Yeast: \(beer.ingredients.yeast ?? "Unknown")"
        lblFirstBrew.text = "First brewed: \(beer.first_brewed ?? "Unknown")"
        lblDescription.text = beer.desciption
        var foodPairing = ""
        for i in 0 ... beer.food_pairing.count - 1 {
            foodPairing = foodPairing + "- " + beer.food_pairing[i] + "\n"
        }
        print("test", foodPairing)
        lblFoodParing.text = foodPairing
        lblTags.text = beer.tagline
        lblFinalVolume.text = "Final volume: \(beer.volume.value ?? 0)L"
        lblBoilVolume.text = "Boil volume: \(beer.boil_volume.value ?? 0)L"
        lblTargetOF.text = "Original Gravity Target: \(beer.target_og ?? 0)"
        lblTargetFG.text = "Final Gravity Target: \(beer.target_fg ?? 0)"
        lblSRM.text = "SRM: \(beer.srm ?? 0)"
        lblPh.text = "PH: \(beer.ph ?? 0.0)"
        lblAttenu.text = "Attenuation level: \(beer.attenuation_level ?? 0)"
        lblBreTips.text = beer.brewers_tips
        lblContribute.text = "Contributed by \(beer.contributed_by ?? "Unknown")"
        
        var malts = ""
        beer.ingredients.malt?.forEach({ malt in
            malts = malts + ("\(malt.name ?? "") - \(malt.amount?.value ?? 0)g \n")
        })
        lblMalts.text = malts
        
        var hops = ""
        beer.ingredients.hops?.forEach({ hop in
            hops = hops + ("\(hop.name ?? "") - \(hop.amount?.value ?? 0)g,  \(hop.add ?? "") \(hop.attribute ?? "") \n")
        })
        lblHops.text = hops
    }
    @IBAction func onTapBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
