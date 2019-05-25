//
//  loadingScreen.swift
//  Cestou
//
//  Created by Jobe Diego Dylbas dos Santos on 13/05/19.
//  Copyright © 2019 Guilherme Piccoli. All rights reserved.
//

import UIKit

class loadingScreen: UIView {
    let screenRect = UIScreen.main.bounds
    
    //initWithFrame to init view from code
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        
        self.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        self.tag = 4095 // #fff
        
        actInd.center = self.center
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.gray
        actInd.startAnimating()
        
        addSubview(actInd)
    }
}
