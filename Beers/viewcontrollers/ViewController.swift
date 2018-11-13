//
//  ViewController.swift
//  Beers
//
//  Created by Sargon Zi on 11/12/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var beersCollectionView: UICollectionView!
    
    var beerList: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beersCollectionView.dataSource = self
        beersCollectionView.delegate = self
        
        //Register cell
        CellRegisterUtil.registerCell(nibName: "BeerCollectionViewCell", uiCollectinView: self.beersCollectionView)
        
        //call loadBeers API
        loadBeers()
    }
    
    func loadBeers(){
        Alamofire.request("https://api.punkapi.com/v2/beers", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                let api = response.result.value
                let json = JSON(api!)
                let data = json.array
                if let result = data {
                    var beerList: [Beer] = []
                    
                    result.forEach({ (beer) in
                        beerList.append(Beer.parseToBeerVO(beer))
                    })
                    self.beerList = beerList
                    self.beersCollectionView.reloadData()
                }
                break
            case .failure:
                print("fail api call")
                break
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.beerList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCollectionViewCell" , for: indexPath) as! BeerCollectionViewCell
        //load iv with sdwebimage library
        cell.ivBeer.sd_setImage(with: URL(string: beerList[indexPath.item].image_url!), placeholderImage: UIImage(named: "bottle"))
        cell.lblBeerName.text = beerList[indexPath.item].name!
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2) - 16 * 4/3;
        return CGSize(width: width , height: width * 1.5)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item) is clicked")
        showDetailView();
    }
    
    private func showDetailView() {
        let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "BeerDetailViewController") as! UINavigationController
        _ = navigationViewController.viewControllers[0] as! BeerDetailViewController
        self.present(navigationViewController, animated: true, completion: nil)
    }
}

