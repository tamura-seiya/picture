//
//  ViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/11/02.
//  Copyright (c) 2015年 Seiya Tamura. All rights reserved.
//

import UIKit
import Photos
import CoreData
import iAd


class ViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, MDCSwipeToChooseDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    var myLabel:UILabel!
    var view1:UIView!
    var view2:UIView!
    var view3:UIView!
    var viewAry: [UIView?] = []
    var labelAry:[UILabel] = []

    var backgroundImage = UIImage(named:"construction-worker-shutterstock-e1382708425901-1024x682.jpg")
    var backgroundImage2 = UIImage(named:"uyuni.jpg")
    var backgroundImage3 = UIImage(named:"large.jpg")
    var backgroundImage4 = UIImage(named:"w621_colorful-aurora-105951.jpg")
    var howToImage = UIImage(named:"seiya's Application.001.jpg")
    var howToImage2 = UIImage(named:"seiya's Application.002.jpg")
    var howToImage3 = UIImage(named:"seiya's Application.003.jpg")
    var howToImage4 = UIImage(named:"seiya's Application.004.jpg")
    var howToImage5 = UIImage(named:"seiya's Application.005.jpg")
   
    var timer : NSTimer! //How to 画面のタイマー作成
    var cnt : Float = 0
    var howToImageView:SpringImageView!
    
    var myCollectionView : UICollectionView!
    
    var photos: [PHAsset] = []
    var photosCollectionView: [PHAsset] = [] //"Key"がついたパスのCollectionViewの配列の出力
    var photoArray:[UIImage] = [] //photosから取り出した、UIimageの配列
    var photoImage:UIImage!
    var photoURL:[String] = []
    var photoKeys:String! //PhotoKeys
    var numberPhoto:Int!
    var count1 = 0 //PHAssetURLの画像の変数
    var count2 = 0
    var hennsuu = 10 //numberを決めるのは三つ
    
    var myButton:UIButton!
    var myButton2:UIButton!
    var myButton3:UIButton!
    var vcBtn:UIButton! //画像を読み込むためのボタン
    var vcBtn2:UIButton!
    var svcBtn:UIButton!
    var svcBtn2:UIButton!
    var myActivityIndicator: UIActivityIndicatorView! //インジケータ
    var fvLabel1: UILabel!
    var fvLabel2: UILabel!
    
    var imageCollectionView:[UIImage] = [] //CollectionViewに出すための配列
    var selectPickerString:String! //PickerSelect
    
    var rightSelectPicker:String!
    var leftSelectPicker:String!
    // UIPickerView.
    private var myUIPicker: UIPickerView!
    private var myUIPicker2: UIPickerView!
    var preSelectedLb:UILabel! //labelを表示
    var myValues: [String] = [] //Selectを足すか
    var albumCorrect:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
         //scrollViewを定義
         self.scrollView?.contentSize = CGSizeMake(self.view.frame.width * 3, self.view.frame.size.height)
        
        
        //----------------------------------View----------------------------------------------------------
        
        //View1を生成
        view1 = UIView()

        view1.backgroundColor = UIColor.clearColor()
        
        // 配置する座標を設定する.(中心座標)
        view1.layer.position = CGPoint(x: self.view.frame.size.width / 2,y: self.view.frame.size.height / 2)
        
        //View2を生成
        view2 = UIView()
        view2.backgroundColor = UIColor.clearColor()
        view2.backgroundColor = UIColor(patternImage: backgroundImage2!)
        
        
        // 配置する座標を設定する.(中心座標)
        view2.layer.position = CGPoint(x: self.view.frame.size.width / 2,y: self.view.frame.size.height / 2)
        
        //view3を形成
        view3 = UIView()
        
        //background
        view3.backgroundColor = UIColor.clearColor()
        view3.backgroundColor = UIColor(patternImage: backgroundImage3!)
        
        // 配置する座標を設定する.(中心座標)
        view3.layer.position = CGPoint(x: self.view.frame.size.width / 2,y: self.view.frame.size.height / 2)
        
        
        viewAry = [view1,view2,view3]
        //-----------------------method---------------------------------------------
        
        swipeGesture()
        
        //ボタンを配置
        
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let flag:Bool = appDelegate.firstRun()
        
        var mydefaults = NSUserDefaults.standardUserDefaults()
        
        if (mydefaults.objectForKey("first") != nil){
            
            print("2回目")
            secondButton() //2回目以降のview1作成ボタン
            read()        //CoreDataを読み込む
            readAlbum()   //Albumの名前を呼ぶ
            imageImport() //Photosの配列に URLを入れる
            imageViewAppear() // photoArrayグローバル変数に値が指定した繰り返しの数入る
            create() //TinderUIに画像を設置　====完了
            makeColectionViewBtn() //アルバムを表示するボタン作成
            
        }else{
            
            print("1回目")
            makeButton() //初回起動時のみのボタン配置
        
        }
        
        

        //-----------------------method---------------------------------------------
        
        
        
        ///////////////////////ボタン2///////////////////////////////////////////////
        // Buttonを生成する.
        myButton3 = UIButton()
        
        // サイズを設定する.
        myButton3.frame = CGRectMake(0,0,200,40)
        
        // 背景色を設定する.
        myButton3.backgroundColor = UIColor.whiteColor()
        
        // 枠を丸くする.
        myButton3.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        myButton3.setTitle("Album Pass", forState: UIControlState.Normal)
        myButton3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        myButton3.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
        myButton3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        myButton3.layer.position = CGPoint(x: self.view2.frame.width/2, y:self.view2.frame.height - 70)
        
        // タグを設定する.
        myButton3.tag = 3
        
        // イベントを追加する.
        myButton3.addTarget(self, action: "onClickOption:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view2.addSubview(myButton3)
        
        

        if (mydefaults.objectForKey("first") != nil){
        myButton3.hidden = false
        }else{
         myButton3.hidden = true
         print("secondRun")
        }
        
        
       
        
        //-------------------------swipe------------------------------------------------------------------
        
        myButton2 = UIButton()
        
        // サイズを設定する.
        myButton2.frame = CGRectMake(45,50,200,40)
        
        // 背景色を設定する.
        myButton2.backgroundColor = UIColor.blackColor()
        
//        // 枠を丸くする.
//        myButton2.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        myButton2.setTitle("アルバムを追加する", forState: UIControlState.Normal)
        myButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        
        myButton2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        myButton2.layer.position = CGPoint(x: self.view2.frame.width / 2, y:self.view2.frame.width / 6) //70
        
        
        // タグを設定する.
        myButton2.tag = 2
        
        // イベントを追加する.
        myButton2.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view2.addSubview(myButton2)
    /////////////////////////////////////////////////////////////////////////////////////////
//        //上へのスワイプを定義
//        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
//        upSwipe.direction = .Up
//        
//        //下へのスワイプを定義
//        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
//        downSwipe.direction = .Down
//        
//        //leftSwipeで足す
//        view.addGestureRecognizer(upSwipe)
//        view.addGestureRecognizer(downSwipe)
//        
        //-------------------------swipe------------------------------------------------------------------
        
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=========================Photo=================================================================
    
    func firstRun() -> Bool {
        //UserDefaults
        var mydefaults = NSUserDefaults.standardUserDefaults()
        
        if (mydefaults.objectForKey("first") != nil){
            return false
        }
        
        mydefaults.setObject("flag", forKey: "first")
        
        mydefaults.synchronize()
        
        return true
    }

    
    func getAllPhoto(sender:UIButton){
        
        firstRun()
        
        makeIndicator() //インジケータ表示がされない
        print("before")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        //////////////////////////非同期処理///////////////////////////
            // 画像をすべて取得
            let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
            assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
                
                
                var asseal = asset as! PHAsset
                
                
                PHImageManager.defaultManager().requestImageDataForAsset(asseal, options: PHImageRequestOptions(), resultHandler:
                    {
                        (imagedata, dataUTI, orientation, info) in
                        
                        if (info![NSString(string: "PHImageFileURLKey")] != nil)
                        {
                            var path = info![NSString(string: "PHImageFileURLKey")] as! NSURL
                            var strUrl = path.absoluteString
                            self.setCameraRoll(strUrl)
                            print("strUrl = \(strUrl)")
                        }
                })
                
                 self.vcBtn2.enabled = true //ボタンを触れるようにする
                 self.myActivityIndicator.hidden = true
                 self.fvLabel1.text = "Loading Success \n Push Start"
                 self.fvLabel1.numberOfLines = 2
                 self.scrollView.contentOffset = CGPointMake(0, 0);
            }
            
///////////////////////////////////////////////////////////////////////////////////////////////////
        })
        
        self.scrollView.contentOffset = CGPointMake(view1.frame.size.width * 2, 0); //scrollViewの位置をずらす
        
        // howto画面のイメージ作成
        
        howToImageView = SpringImageView(frame: CGRectMake(0,0,self.view.frame.size.width ,self.view.frame.size.height))
       
        howToImageView.image = howToImage
        
        
        self.view3.addSubview(howToImageView)
        
        view3.bringSubviewToFront(myActivityIndicator) //indicatorを一番前に出す

        
        howToImageView.animation = "squeezeDown"
        howToImageView.curve = "easeIn"
        howToImageView.duration = 1.0
        howToImageView.animate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
            
        }
    
    
    //取得したURLをCoredataに保存
    func setCameraRoll(strUrl:String){
        //delegateからデータを呼び込むための、定義(get the discription entity name)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
            let managedObjectContext = appDelegate.managedObjectContext
            
            //新しくデータを追加するためのEntityを作成します
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: managedObjectContext)
            
            
            //Todo EntityからObjectを生成し、 Attributesに接続して値を代入
            let picture = managedObject as! Picture
            picture.cameraroll = strUrl
        
            appDelegate.saveContext()
        }
    
    //Coredataを読み込む
    func read(){
        //Delegateを読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
            let managedObjectContext = appDelegate.managedObjectContext
            
            //Entityを設定
            
            let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
            
            let fetchRequest = NSFetchRequest(entityName: "Picture")
            fetchRequest.entity = entityDiscription
            
            //errorが発生した際にキャッチするための変数
            var error : NSError? = nil
            
            //フェッチリクエスト(データの検索と取得処理の実行)
            do {
                //Pictureの中の画像の数を抽出
                //resultsという配列に格納
                let results : NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
                print("データの数 = \(results.count)")
                
                //managedObjectという変数をダウンキャストしてtodoというものを定義している。
                //上でresultsを定義している
    
                for managedObject in results{
                    
                let picture = managedObject as! Picture
//                print("cameraroll: \(picture.cameraroll), album:\(picture.album)")    //print("cameraroll: \(picture.cameraroll)")
                }
            } catch let error1 as NSError {
                error = error1
            }
        
    }
    
    func imageImport(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
            let managedObjectContext = appDelegate.managedObjectContext
            
            //Entityを設定する設定
            let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
            
            
            let fetchRequest = NSFetchRequest(entityName: "Picture")
            fetchRequest.entity = entityDiscription
        
            
            do{
                let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
                
                //数を取得
                
                
                for managedObject in fetchResults!{
                    
                    
                    
                    if count1 == 10 {
                         break
                    }
                    
                    count1++
                    
                    let picture = managedObject as! Picture
                    
                    
                    //画像を表示させる
                    let filePath: String = picture.cameraroll!
                    print(filePath)
                    let fileUrl = NSURL(string:filePath)
                    
                    //PHAssetUrl取得
                    PHAssetForFileURL(fileUrl!)
                
        
                    appDelegate.saveContext()
                }
                
                
            }catch{
                print("could not catch")
            }
        
    }
    
    
    //PHAssetURLを取得
    func PHAssetForFileURL(fileUrl: NSURL){
        
        var imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .Current
        imageRequestOptions.deliveryMode = .FastFormat
        imageRequestOptions.resizeMode = .Fast
        imageRequestOptions.synchronous = true
        
    
        
        let fetchResult = PHAsset.fetchAssetsWithOptions(nil)
        print("fetchResult = \(fetchResult)")
        
        
        //////////////数を呼び込まれる回数に対して、同時に上がっていかないと、画像が変化しない
        
        photos.append(fetchResult[count1] as! PHAsset)
        print("photos = \(photos) + \(count1)")
       
//        print("photos = \(photos)")
//        print("photos.count = \(photos.count)")
//        
//        print("fetchResult.count = \(fetchResult.count)")
        
        }
    
    func imageViewAppear() {
        //PHAssetをUIImageに変換して、画像の配列を作る
        
            for (var i = 0;i < 10 ; i++){
                     
            let phimgr:PHImageManager = PHImageManager();
            phimgr.requestImageForAsset(photos[i],
                targetSize: CGSize(width: 320, height: 320),
                contentMode: .AspectFill, options: nil) {
                    image, info in
                    //ここでUIImageを取得します。
                    self.photoArray.append(image!)  //UIImageを配列に取得する
                    let urlKey = info!["PHImageFileURLKey"]
                    print(urlKey)
//                    print("info = \(info)")
                    if (urlKey == nil){
                        self.photoURL.append("nil")
                        print("urlKey == nil")
                    }else{
                        let strUrl = urlKey!.absoluteString
                        self.photoURL.append(strUrl)
                    }
                    
                   /////////////////////////nilの時の対処////////////////////////////
                   //最初の10個の配列がnil
                   //photoUrlとphotoArrayのkeyが対応しているか
                    
                    print("photoURL = \(self.photoURL)") //nil20個
                    print("photoURL = \(self.photoURL.count)") //数を取得
//                    print("photoArray.count = \(self.photoArray.count)") //photoarrayの数
    
                    
            }
            
        }
    }


    
    //=========================Photo=================================================================
    
    
    func swipeGesture(){
        
        //scroll画面の初期位置
        scrollView.contentOffset = CGPointMake(0, 0);
        
        for i in 0...2 {
            
            var x:CGFloat = 0
            let y:CGFloat = 0
            
            if i == 0 {
                //x = 0
            } else if i == 1 {
                x = self.view.frame.size.width
            } else if i == 2 {
                x = self.view.frame.size.width*2
            }
            
            // Scrollviewに追加
            viewAry[i]!.frame = CGRectMake(x, y, self.view.frame.width, self.view.frame.size.height)
            
            // Scrollviewに追加
            scrollView.addSubview(viewAry[i]!)
            
            // １ページ単位でスクロールさせる
            scrollView.pagingEnabled = true
        }
    }
      //-------------------------------TinderUI-------------------------------------------------------
        //画像を生成する
     func create(){
        
        for (var i = 0;i < hennsuu; i++){
            let options = MDCSwipeToChooseViewOptions()
            options.delegate = self
            options.likedText = rightSelectPicker //右にスワイプした時に、テキストをを表示
            options.likedColor = UIColor.blueColor()
            options.nopeText = leftSelectPicker //左にスワイプした時に、テキスト表示
            options.onPan = { state -> Void in
                if state.thresholdRatio == 1 && state.direction == MDCSwipeDirection.Left {
                    print("Photo deleted!")
                }
            }
            
            let rect:CGRect = CGRectMake(self.view.bounds.size.width/2 - 120, self.view.bounds.size.height/2 - 150, 240, 300)
            let view:MDCSwipeToChooseView = MDCSwipeToChooseView(frame: rect, options: options)
            //画像出力完了
            
            ////////////////photoArrayとphotoUrlの画像配列/////////////////////////////////
            photoImage = photoArray[i]
            photoKeys = photoURL[i]
            
            
            
            
            view.imageView.image = photoImage
            
            view.imageView.contentMode = .ScaleAspectFill
            self.view2.addSubview(view)

            }
       }
        
        //cancellのときの対応
        func viewDidCancelSwipe(view: UIView) -> Void{
            print("Couldn't decide, huh?")
        }
    /////////////右へ割り振った時にパスをつけてコアデータに保存///////////////////////////////////////////////////
    
    func rightRead(){
        //Delegateを読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //Entityを設定
        
        let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        fetchRequest.entity = entityDiscription
        
        //errorが発生した際にキャッチするための変数
        var error : NSError? = nil
        
        //フェッチリクエスト(データの検索と取得処理の実行)
        do {
            //Pictureの中の画像の数を抽出
            //resultsという配列に格納
            let results : NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
            print("データの数 = \(results.count)")
            
            
            let predicate = NSPredicate(format: "%K = %@", "cameraroll","file:///var/mobile/Media/DCIM/100APPLE/IMG_0086.PNG")
            fetchRequest.predicate = predicate
            
            print("photoKeys = \(photoKeys)") //全てnil

            for managedObject in results{
                
                let picture = managedObject as! Picture
                
                picture.album = rightSelectPicker
                print("rightselectPickerString = \(rightSelectPicker)")
            
            }
        
        } catch let error1 as NSError {
            error = error1
        }
        //データの保存の処理
        appDelegate.saveContext()

    }
    
    func leftRead(){
        //Delegateを読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //Entityを設定
        
        let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Picture")
        fetchRequest.entity = entityDiscription
        
        //errorが発生した際にキャッチするための変数
        var error : NSError? = nil
        
        //フェッチリクエスト(データの検索と取得処理の実行)
        do {
            //Pictureの中の画像の数を抽出
            //resultsという配列に格納
            let results : NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
            
            //データを一件取得する
            //ここの画像の名前をどうすればいいか
            let predicate = NSPredicate(format: "%K = %@", "cameraroll","file:///var/mobile/Media/DCIM/100APPLE/IMG_0086.PNG")
            fetchRequest.predicate = predicate
            
            print("photoKeys = \(photoKeys)")
            
            for managedObject in results{
                
                let picture = managedObject as! Picture
//                picture.album = leftSelectPicker
                picture.album = leftSelectPicker //名前をselectと一緒にする
                print("leftselectPickerString = \(leftSelectPicker)")
            }
            
        } catch let error1 as NSError {
            error = error1
        }
        appDelegate.saveContext()
        
    }

    
    /////////////左へ割り振った時にパスをつけてコアデータに保存///////////////////////////////////////////////////
    
        //左か右のどちらかに傾き切ったら、どちらを選択したのか確定
        func view(view: UIView, shouldBeChosenWithDirection: MDCSwipeDirection) -> Bool{
            if (shouldBeChosenWithDirection == MDCSwipeDirection.Left) {
                print("Photo deleted!")
                leftRead()
                
                return true; //NO
            } else if (shouldBeChosenWithDirection == MDCSwipeDirection.Right){
                print("Photo saved!")
                rightRead()
                

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
        
         //-----------------------------------------------------------------------------------------------
  
    
    //=========================Collection=============================================================

    
    //==================AlertView=============================================================
    func onClickMyButton(sender: UIButton) {
       
       
//        if myButton3.hidden != true{
//           myButton3.hidden = true
//           alertMaking()
//           print("Button")
//        }else if myUIPicker.hidden != true && myUIPicker2.hidden != true{
//           myUIPicker.hidden = true
//           myUIPicker2.hidden = true
//           alertMaking()
//           print("UIPIcker")
//        }else{
//           alertMaking()
//          print("else")
//        }
                
//        //MyButtonと同じ作業をして、表示させる
//        if myButton3.hidden || myUIPicker.hidden || myUIPicker2.hidden{
//           alertMaking()
//          print("1回目")
//        }else{
//          myButton3.hidden = true
//          myUIPicker.hidden = true
//          myUIPicker2.hidden = true
//          alertMaking()
//          print("2回目")
//        }
        
        
        alertMaking()
    }
    
    func alertMaking(){
    
        
        // Alert生成.
        let myAlert: UIAlertController = UIAlertController(title: "新しくアルバムを追加する", message: "Album Name", preferredStyle: UIAlertControllerStyle.Alert)
        
        // OKアクション生成.
        let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
            
            for albumname in myAlert.textFields!{
                print("albumname = \(albumname)")
                let text = albumname.text
                
                if (text == "" ){
                    
                    self.myButton3.hidden = false
                    
                    let myAlert: UIAlertController = UIAlertController(title: "アルバム名を入力してください", message: "必須項目です", preferredStyle: .Alert)
                    
                    // OKのアクションを作成する.
                    let myOkAction = UIAlertAction(title: "OK", style: .Default) { action in
                        print("Action OK!!")
                    }
                    
                    // OKのActionを追加する.
                    myAlert.addAction(myOkAction)
                    
                    // UIAlertを発動する.
                    self.presentViewController(myAlert, animated: true, completion: nil) //アルバムを入力して、何もなかった時に、Alertを表示する
                    self.myButton3.hidden = true
                    
                    
                }else{
                    
                    self.albumTinderAlbum(text!) //tinderalbumに画像を抽出
                    print("text =  \(text)")
                    self.myButton3.hidden = false
                    
                }
            }
            
        }
        // Cancelアクション生成.
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction!) -> Void in
            print("Cancel")
            
            self.view2.addSubview(self.myButton3)
        }
        
        // AlertにTextFieldを追加.
        myAlert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            
            
            // NotificationCenterを生成.
            let myNotificationCenter = NSNotificationCenter.defaultCenter()
            
            // textFieldに変更があればchangeTextFieldメソッドに通知.
            myNotificationCenter.addObserver(self, selector: "changeTextField:", name: UITextFieldTextDidChangeNotification, object: nil)
        }
        
        // Alertにアクションを追加.
        myAlert.addAction(OkAction)
        myAlert.addAction(CancelAction)
        
        // Alertを発動.
        presentViewController(myAlert, animated: true, completion: nil)
        //    myUIPicker.hidden = true
        //    myButton3.hidden = false ////画像の調整

    }
    
    /*
    textFieldに変更があった時に通知されるメソッド.
    */
    func changeTextField (sender: NSNotification) {
    let textField = sender.object as! UITextField
        
        // 入力された文字を表示.
        print(textField.text)
    }
    
    func readAlbum(){
        //Delegateを読み込む
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //Entityを設定
        
        let entityDiscription = NSEntityDescription.entityForName("Albumname", inManagedObjectContext: managedObjectContext)
        
        let fetchRequest = NSFetchRequest(entityName: "Albumname")
        fetchRequest.entity = entityDiscription
        
        //errorが発生した際にキャッチするための変数
        var error : NSError? = nil
        
        //フェッチリクエスト(データの検索と取得処理の実行)
        do {
            //Pictureの中の画像の数を抽出
            //resultsという配列に格納
            let results : NSArray = try managedObjectContext.executeFetchRequest(fetchRequest)
            print("resulsssssssssssデータの数 = \(results.count)")
            
            //managedObjectという変数をダウンキャストしてtodoというものを定義している。
            //上でresultsを定義している
            
            for managedObject in results{
                
                let album = managedObject as! Albumname
               
                myValues.append(album.createAlbum!)
                print("myValues = \(myValues)")
                print("albumName: \(album.createAlbum)") //albumname 取得
            }
        } catch let error1 as NSError {
            error = error1
        }
        
    }
    
    func albumTinderAlbum(text:String){
        
        //アルバムネームを保存
        //delegateからデータを呼び込むための、定義(get the discription entity name)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
        let managedObjectContext = appDelegate.managedObjectContext
        
        //新しくデータを追加するためのEntityを作成します
        let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Albumname", inManagedObjectContext: managedObjectContext)
        
        
        
        //Todo EntityからObjectを生成し、 Attributesに接続して値を代入
        let album = managedObject as! Albumname

        album.createAlbum = text
        
        appDelegate.saveContext()
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
    pickerに表示する行数を返すデータソースメソッド.
    (実装必須)
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return myValues.count
        //CollectinViewの数の分だけ
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        let pickerLabel = UILabel()
        let titleData = myValues[row] as! String
        //PickerViewの文字のプロパティ
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "HiraKakuProN-W3", size: 25.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        
        // fontサイズ、テキスト
        pickerLabel.attributedText = myTitle
        // 中央寄せ ※これを指定しないとセンターにならない
        pickerLabel.textAlignment = NSTextAlignment.Center
        pickerLabel.frame = CGRectMake(0, 0, 200, 30)
    
        // ラベルを角丸に
        pickerLabel.layer.masksToBounds = true
        pickerLabel.layer.cornerRadius = 5.0
        
        // 既存ラベル、選択状態のラベルが存在している
        if  let lb = pickerView.viewForRow(row, forComponent: component) as? UILabel,
            let selected = self.preSelectedLb{
                // 設定
                self.preSelectedLb = lb
                self.preSelectedLb.backgroundColor = UIColor.orangeColor()
                self.preSelectedLb.textColor = UIColor.blackColor()
        }
        
        return pickerLabel
    }
    /*
    pickerが選択された際に呼ばれるデリゲートメソッド.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(myValues[row])")
        //タグ付け機能を使って、どうやって使い分けるか
        
        // 選択状態のラベルを代入
        self.preSelectedLb = pickerView.viewForRow(row, forComponent: component) as! UILabel
        // ピッカーのリロードでviewForRowが呼ばれる
        pickerView.reloadComponent(component)
        
        if pickerView.tag == 1{
            leftSelectPicker = myValues[row]
            print(leftSelectPicker)
            print("左")
        }else if pickerView.tag == 2{
            rightSelectPicker = myValues[row]

            print(rightSelectPicker)
            print("右")
        }else{
        }
        print("didSelectRow")
//        selectPickerString = myValues[row]
    }
    
    func onClickOption(sender: UIButton){
        
        readAlbum()  //albumnameの値を取得
        
        myButton3.hidden = true //押した瞬間にボタンを隠す
        //-------------------------PickerView------------------------------------------------------
        myUIPicker = UIPickerView()
        
        // サイズを指定する.
        myUIPicker.frame = CGRectMake(0,400,self.view2.bounds.width/2, 180.0)
        
        myUIPicker.tag = 1
        
        // Delegateを設定する.
        myUIPicker.delegate = self
        
        // DataSourceを設定する.
        myUIPicker.dataSource = self
        
        
        // Viewに追加する.
        self.view2.addSubview(myUIPicker)
        
        myUIPicker2 = UIPickerView()
        
        // サイズを指定する.
        myUIPicker2.frame = CGRectMake(self.view2.bounds.width/2,400,self.view2.bounds.width/2, 180.0)
        
        myUIPicker2.tag = 2
        
        // Delegateを設定する.
        myUIPicker2.delegate = self
        
        // DataSourceを設定する.
        myUIPicker2.dataSource = self
        
        // Viewに追加する.
        self.view2.addSubview(myUIPicker2)
        
    
    }
    
    func makeColectionViewBtn(){
        
        
            myButton = UIButton()
            
            // サイズを設定する.
            //CGRectMake(x,次の始まる視点 y, 横の大きさ, たての大きさ)
//            myButton.frame = CGRectMake(20, CGFloat(i * 120), 100, 100)
        
            myButton.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 200, 100)
        
            // 背景色を設定する.
            myButton.backgroundColor = UIColor.whiteColor()
            
            // 枠を丸くする.
            myButton.layer.masksToBounds = true
        
            myButton.layer.position = CGPoint(x: self.view3.frame.size.width / 2,y: self.view3.frame.size.height / 2)

           // タイトルを設定する(通常時).
            
           //albumCorrect = myValues[i]
            myButton.setTitle("Show the Album", forState: UIControlState.Normal)
            
            myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            // タイトルを設定する(ボタンがハイライトされた時).
            myButton.setTitle("Album表示", forState: UIControlState.Highlighted)
            myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
//            // コーナーの半径を設定する.
//            myButton.layer.cornerRadius = 20.0
        
            // タグを設定する.
//            myButton.tag = i
        
            // イベントを追加する.
            myButton.addTarget(self, action: "pushSecondView:", forControlEvents: .TouchUpInside)
            
            // ボタンをViewに追加する.
            self.view3.addSubview(myButton)
            
        }
    
    func pushSecondView(sender:UIButton){
        
        imageIn()
        
        //view三枚目のボタンを押したら発動する
        let secondViewcontroller: NavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("secondVC") as! NavigationController
        
        //アニメーション
        secondViewcontroller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        //modalで遷移する
        self.presentViewController(secondViewcontroller, animated: true, completion:nil)

    }
    
    func imageIn(){
        //Delegateにデータを追加
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate.myValues = myValues //Delegateの変数を代入して表示する
        print(appDelegate.myValues)
    }
///////////////////////////////////////////FirstView////////////////////////////////////////////////////
    func makeButton(){
        
        print("makeButton")
        // Buttonを生成する.
        vcBtn = UIButton()
        
        // サイズを設定する.
        vcBtn.frame = CGRectMake(0,0,self.view1.frame.size.width,self.view1.frame.size.height / 2 )
        
        // 背景色を設定する.
        vcBtn.backgroundColor = UIColor.blueColor()
        
        // 枠を丸くする.
        vcBtn.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
//        vcBtn.setTitle("Option", forState: UIControlState.Normal)
//        
//        vcBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        
//        // タイトルを設定する(ボタンがハイライトされた時).
//        vcBtn.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
//        vcBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        vcBtn.setImage(backgroundImage, forState: UIControlState.Normal)
        
        vcBtn.alpha = 0.5
        
        // タグを設定する.
        vcBtn.tag = 3
        
        // イベントを追加する.
        vcBtn.addTarget(self, action: "getAllPhoto:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view1.addSubview(vcBtn)
        
        //ボタン1の画像を表示
        fvLabel1 = UILabel(frame: CGRectMake(45,self.view.frame.size.height / 5.7,250,100))
        
        fvLabel1.textAlignment = NSTextAlignment.Center
        fvLabel1.font = UIFont(name: "ChalkboardSE-Light", size: 30)!
        fvLabel1.text = "All Album Save"
        fvLabel1.textColor = UIColor.blackColor()
        
        
        // Viewの背景色を青にする.
        
        
        // ViewにLabelを追加.
        self.view1.addSubview(fvLabel1)

        
        // Buttonを生成する.
        vcBtn2 = UIButton()
        
        // サイズを設定する.
        vcBtn2.frame = CGRectMake(0,self.view1.frame.size.height / 2,self.view1.frame.size.width,self.view1.frame.size.height / 2 )
        
            
        // タイトルを設定する(通常時).
        vcBtn2.setTitle("画像を読みこむ", forState: UIControlState.Normal)
        
        vcBtn2.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        // タイトルを設定する(ボタンがハイライトされた時).
        vcBtn2.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
        vcBtn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        vcBtn2.setImage(backgroundImage3, forState: UIControlState.Normal)
        
        vcBtn2.alpha = 0.7
        
        
        // イベントを追加する.
        vcBtn2.addTarget(self, action: "start:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view1.addSubview(vcBtn2)
        
        //ボタン2の画像表示
        fvLabel2 = UILabel(frame: CGRectMake(45,self.view.frame.size.height / 1.5,250,100))
        
        fvLabel2.textAlignment = NSTextAlignment.Center
        fvLabel2.font = UIFont(name: "ChalkboardSE-Light", size: 30)!
        fvLabel2.text = "Start"
        fvLabel2.textColor = UIColor.blackColor()
        
        self.view1.addSubview(fvLabel2)
        
        vcBtn2.enabled = false //ボタンが押せないようにする
        print("enabled　ミス")
    
        }
    
    func secondButton(){
        // 二回目以降に呼ばれる
        svcBtn = UIButton()
        
        // サイズを設定する.
        svcBtn.frame = CGRectMake(0,0,self.view1.frame.size.width,self.view1.frame.size.height / 2 )
        
        // 背景色を設定する.
        svcBtn.backgroundColor = UIColor.blueColor()
        
        // 枠を丸くする.
        svcBtn.layer.masksToBounds = true
        
        svcBtn.setImage(backgroundImage, forState: UIControlState.Normal)
        
        svcBtn.alpha = 0.5
        
        // タグを設定する.
        svcBtn.tag = 3
        
        // イベントを追加する.
        svcBtn.addTarget(self, action: "pushSecondView:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view1.addSubview(svcBtn)
        
        //ボタン1の画像を表示
        let myLabel: UILabel = UILabel(frame: CGRectMake(45,self.view.frame.size.height / 5.7,250,100))
        
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.font = UIFont(name: "ChalkboardSE-Light", size: 30)!
        myLabel.text = "Album"
        myLabel.textColor = UIColor.blackColor()
        
        
        // Viewの背景色を青にする.
        
        
        // ViewにLabelを追加.
        self.view1.addSubview(myLabel)
        
        
        // Buttonを生成する.
        svcBtn2 = UIButton()
        
        // サイズを設定する.
        svcBtn2.frame = CGRectMake(0,self.view1.frame.size.height / 2,self.view1.frame.size.width,self.view1.frame.size.height / 2 )
        
        
        // 枠を丸くする.
        svcBtn2.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        svcBtn2.setTitle("画像を読みこむ", forState: UIControlState.Normal)
        
        svcBtn2.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        
        // タイトルを設定する(ボタンがハイライトされた時).
        svcBtn2.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
        svcBtn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        svcBtn2.setImage(backgroundImage3, forState: UIControlState.Normal)
        
        svcBtn2.alpha = 0.5
        
        
        // イベントを追加する.
        svcBtn2.addTarget(self, action: "upload:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view1.addSubview(svcBtn2)
        
        //ボタン2の画像表示
        let mylabel: UILabel = UILabel(frame: CGRectMake(45,self.view.frame.size.height / 1.5,250,100))
        
        mylabel.textAlignment = NSTextAlignment.Center
        mylabel.font = UIFont(name: "ChalkboardSE-Light", size: 30)!
        mylabel.text = "Update"
        mylabel.textColor = UIColor.blackColor()
        
        self.view1.addSubview(mylabel)
        
        
    }
            func makeIndicator(){
        //ボタンを配置
        print("makeingicator")
        //getAllphotoに含まれる
        // インジケータを作成する.
        myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.frame = CGRectMake(self.view1.frame.size.width / 2,50, 100, 100)
        myActivityIndicator.center = self.view.center
            
        myActivityIndicator.color = UIColor.redColor()
        
        // アニメーションが停止している時もインジケータを表示させる.
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
            
            
        // アニメーションを開始する.
        myActivityIndicator.startAnimating()
        
        //ボタンに効果を与える
        vcBtn.alpha = 0.1
        
        fvLabel1.text = "Loading Now"
        
        // インジケータをViewに追加する.
        self.view3.addSubview(myActivityIndicator)

        }
    
    
    func start(sender:UIButton){
    //画像を読み終わった後に入れる作業
    //この中に新しくボタンを作るメソッドを書く
        read()        //CoreDataを読み込む
        readAlbum()   //Albumの名前を呼ぶ
        imageImport() //Photosの配列に URLを入れる
        imageViewAppear() // photoArrayグローバル変数に値が指定した繰り返しの数入る
        create() //TinderUIに画像を設置　====完了
        makeColectionViewBtn() //アルバムを表示するボタン作成
        self.howToImageView.hidden = true // trueにする
        
    }
    
    func upload(sender:UIButton){
     //2回目以降に呼び出される関数
        
        
        // 画像をすべて取得
        let assets: PHFetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
        assets.enumerateObjectsUsingBlock { (asset, index, stop) -> Void in
            
            
            var asseal = asset as! PHAsset
            
            
            PHImageManager.defaultManager().requestImageDataForAsset(asseal, options: PHImageRequestOptions(), resultHandler:
                {
                    (imagedata, dataUTI, orientation, info) in
                    
                    if (info![NSString(string: "PHImageFileURLKey")] != nil)
                    {
                        var path = info![NSString(string: "PHImageFileURLKey")] as! NSURL
                        var strUrl = path.absoluteString
                        if (strUrl == "画像のパスを取得") {
                            
                        }else{
                        self.setCameraRoll(strUrl)
                        }
                        print("strUrl = \(strUrl)")
                    }
            })
        }
        
        myActivityIndicator.hidden = true //インジケータを止める
        //Animationを入れるようにする
        vcBtn2.enabled = true //ボタンを触れるようにする
        print("読み込み完了")

       
    }
    
    func onUpdate(sender:NSTimer){
        //タイマーの時の処理
        cnt += 1
    
        if cnt == 1{
            howToImageView.image = howToImage2
            howToImageView.animation = "squeezeDown"
            howToImageView.curve = "easeIn"
            howToImageView.duration = 1.5
            howToImageView.animate()
        }else if cnt == 2{
            howToImageView.image = howToImage3
            howToImageView.animation = "squeezeDown"
            howToImageView.curve = "easeIn"
            howToImageView.duration = 1.5
            howToImageView.animate()
        }else if cnt == 3{
            howToImageView.image = howToImage4
            howToImageView.animation = "squeezeDown"
            howToImageView.curve = "easeIn"
            howToImageView.duration = 1.5
            howToImageView.animate()
            
        }else if cnt == 4{
            howToImageView.image = howToImage5
            howToImageView.animation = "squeezeDown"
            howToImageView.curve = "easeIn"
            howToImageView.duration = 1.5
            howToImageView.animate()
        }else if cnt == 5{
//            self.scrollView.contentOffset = CGPointMake(0, 0); //scrollViewの位置を初期画面に戻す
            timer.invalidate()
            vcBtn.enabled = false
            print("タイマーを止める")
        }else{
        
        }
        
        
    }

}


    







