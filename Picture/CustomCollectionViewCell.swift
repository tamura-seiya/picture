//
//  CustomCollectionViewCell.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/17.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit

class CustomCollectionViewCell : UICollectionViewCell{
    
    var imgView : UIImageView?
    var textLabel : UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        super.init(frame: frame)
        // ... and then the rest of the code
        imgView!.alpha = 0.2
        imgView?.layer.shouldRasterize = true
        imgView!.layer.rasterizationScale = 0.6;
        
        //丸くする
        imgView!.layer.cornerRadius = 60
        imgView!.clipsToBounds = true
        
        self.contentView.addSubview(imgView!)
        
        // UILabelを生成
        textLabel = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        textLabel?.backgroundColor = UIColor.clearColor()
        textLabel?.textAlignment = NSTextAlignment.Center
        textLabel?.font = UIFont(name: "ChalkboardSE-Light", size: 24)
        //ArialHebrew AvenirNext-UltraLightItalic ChalkboardSE-Bold ChalkboardSE-Light Cochin Cochin-Italic
        //Courier
        
        // Cellに追加.
        self.contentView.addSubview(textLabel!)
        
    }
    
    
    
    
}
