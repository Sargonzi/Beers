//
//  CellRegister.swift
//  Beers
//
//  Created by Sargon Zi on 11/13/18.
//  Copyright © 2018 PADC. All rights reserved.
//

import UIKit

class CellRegisterUtil {
    
    static func registerCell(nibName: String, uiCollectinView: UICollectionView){
        let nib = UINib(nibName: nibName, bundle: nil)
        uiCollectinView.register(nib, forCellWithReuseIdentifier: nibName)
    }
}
