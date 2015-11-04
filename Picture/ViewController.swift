//
//  ViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/02.
//  Copyright (c) 2015年 Seiya Tamura. All rights reserved.
//

import UIKit
import Photos

var photoAssets = [PHAsset]()

class ViewController: UIViewController, MDCSwipeToChooseDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    var myLabel:UILabel!
    var view1:UIView!    
    var view2:UIView!
    var view3:UIView!
    var viewAry: [UIView?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         //scrollViewを定義
         self.scrollView?.contentSize = CGSizeMake(self.scrollView.frame.width * 3, self.scrollView.frame.size.height)
        
        //----------------------------------View----------------------------------------------------------
        
        //View1を生成
        view1 = UIView()

        view1.backgroundColor = UIColor.blueColor()
        
        // 配置する座標を設定する.(中心座標)
        view1.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        
        //View2を生成
        view2 = UIView()
        view2.backgroundColor = UIColor.yellowColor()
        
        // 配置する座標を設定する.(中心座標)
        view2.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        //view3を形成
        view3 = UIView()
        
        //background
        view3.backgroundColor = UIColor.blackColor()
        
        // 配置する座標を設定する.(中心座標)
        view3.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        viewAry = [view1,view2,view3]

        //------------------------------------------------------------------------------------------------
        
        //method
        swipeGesture()
        create()


        
        //labelを生成
        myLabel = UILabel(frame: CGRectMake(0,0,200,50))
        myLabel.backgroundColor = UIColor.orangeColor()
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        myLabel.text = "Hello Swift!!"
        myLabel.textColor = UIColor.whiteColor()
        myLabel.shadowColor = UIColor.grayColor()
        myLabel.textAlignment = NSTextAlignment.Center
        
        // 座標設定
        myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 200)
        
        // Viewの背景色を青にする.
        self.view.backgroundColor = UIColor.cyanColor()
        //このコードで追加となる
        self.view1.addSubview(myLabel)
        
        
        //上へのスワイプを定義
        var upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        upSwipe.direction = .Up
        
        //下へのスワイプを定義
        var downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        downSwipe.direction = .Down
        
        //leftSwipeで足す
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipeGesture(){
        
        // １ページ単位でスクロールさせる
        scrollView.pagingEnabled = true
        
        //scroll画面の初期位置
        scrollView.contentOffset = CGPointMake(0, 0);
        
        for i in 0...2 {
            
            var x:CGFloat = 0
            var y:CGFloat = 0
            
            if i == 0 {
                //x = 0
            } else if i == 1 {
                x = 375
            } else if i == 2 {
                x = 375*2
            }
            
            // Scrollviewに追加
            viewAry[i]!.frame = CGRectMake(x, y, self.scrollView.frame.width, self.scrollView.frame.size.height)
            
            // Scrollviewに追加
            scrollView.addSubview(viewAry[i]!)
        }
    }
      //-------------------------------TinderUI-------------------------------------------------------
        //画像を生成する
     func create(){
        var options = MDCSwipeToChooseViewOptions()
            options.delegate = self
            options.likedText = "Keep"
            options.likedColor = UIColor.blueColor()
            options.nopeText = "Delete"
            options.onPan = { state -> Void in
                if state.thresholdRatio == 1 && state.direction == MDCSwipeDirection.Left {
                    println("Photo deleted!")
                }
            }
            
            var rect:CGRect = CGRectMake(self.view.bounds.size.width/2 - 120, self.view.bounds.size.height/2 - 150, 240, 300)
            var view:MDCSwipeToChooseView = MDCSwipeToChooseView(frame: rect, options: options)
            //        view.imageView.image = UIImage(named: imageName)
            view.imageView.contentMode = .ScaleAspectFill
            self.view2.addSubview(view)
        }
        
        //cancellのときの対応
        func viewDidCancelSwipe(view: UIView) -> Void{
            println("Couldn't decide, huh?")
        }
        
        //左か右のどちらかに傾き切ったら、どちらを選択したのか確定
        func view(view: UIView, shouldBeChosenWithDirection: MDCSwipeDirection) -> Bool{
            if (shouldBeChosenWithDirection == MDCSwipeDirection.Left) {
                println("Photo deleted!")

                return true; //NO
            } else if (shouldBeChosenWithDirection == MDCSwipeDirection.Right){
                println("Photo saved!")

                return true; //YES
            } else {
                // Snap the view back and cancel the choice.
                UIView.animateWithDuration(0.16, animations: { () -> Void in
                    view.transform = CGAffineTransformIdentity
                    view.center = view.superview!.center
                })
                return false;
            }
        }
        
     //左か右、どちらを選択したのか確定したら呼ばれるメソッド
//        func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
//            if wasChosenWithDirection == MDCSwipeDirection.Left {
//                println("Photo deleted!")
//            }else{
//                println("Photo saved!")
//            }
//        }
    //------------------------------------------------------------------------------------------------
    
    func getAllPhotosInfo() {
        photoAssets = []
        
        // 画像をすべて取得
        var assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            photoAssets.append(asset as! PHAsset)
        }
        println("photoAssets = \(photoAssets)")
        
        enum PHAssetMediaType : Int {
            case Image
            case Video
            case Audio
        }
    }

    
    //ここでswipeGestureを定義
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if (sender.direction == .Up){
            myLabel.text = "aa"
        }else if (sender.direction == .Down){
            myLabel.text = "bb"
        }else{
            myLabel.text = "cc"
        }
    }
}