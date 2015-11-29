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


class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource, MDCSwipeToChooseDelegate{

    
    @IBOutlet weak var scrollView: UIScrollView!
    var myLabel:UILabel!
    var view1:UIView!
    var view2:UIView!
    var view3:UIView!
    var viewAry: [UIView?] = []
    
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
    var imageCollectionView:[UIImage] = [] //CollectionViewに出すための配列
    var selectPickerString:String! //PickerSelect
    
    var rightSelectPicker:String!
    var leftSelectPicker:String!
    // UIPickerView.
    private var myUIPicker: UIPickerView!
    private var myUIPicker2: UIPickerView!
    var myValues: [String] = [] //Selectを足すか
    var albumCorrect:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
       
        
         //scrollViewを定義
         self.scrollView?.contentSize = CGSizeMake(self.scrollView.frame.width * 3, self.scrollView.frame.size.height)
        
        
        //----------------------------------View----------------------------------------------------------
        
        //View1を生成
        view1 = UIView()

        view1.backgroundColor = UIColor.clearColor()
        
        // 配置する座標を設定する.(中心座標)
        view1.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        
        //View2を生成
        view2 = UIView()
        view2.backgroundColor = UIColor.clearColor()
        
        // 配置する座標を設定する.(中心座標)
        view2.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        //view3を形成
        view3 = UIView()
        
        //background
        view3.backgroundColor = UIColor.clearColor()
        
        // 配置する座標を設定する.(中心座標)
        view3.layer.position = CGPoint(x: 375/2,y: 675/2)
        
        
        viewAry = [view1,view2,view3]
        //-----------------------method---------------------------------------------
        
        swipeGesture()
        
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let flag:Bool = appDelegate.firstRun()
        
        if flag{
            print("初回起動時")
            getAllPhoto()
            print("読み込み完了")
           
            
        }else{
            print("二回目")
            read()        //CoreDataを読み込む
            readAlbum()   //Albumの名前を呼ぶ
            imageImport() //Photosの配列に URLを入れる
            imageViewAppear() // photoArrayグローバル変数に値が指定した繰り返しの数入る
            create() //TinderUIに画像を設置　====完了
//            myCollectionView.reloadData()
            
        }
        
        

        //-----------------------method---------------------------------------------
        
        

        
        
        //-------------------------label------------------------------------------------------------------

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
        //-------------------------label------------------------------------------------------------------
        
    
        //-------------------------Button----------------------------------------------------------
        
        
        ///////////////////////ボタン2///////////////////////////////////////////////
        // Buttonを生成する.
        myButton3 = UIButton()
        
        // サイズを設定する.
        myButton3.frame = CGRectMake(0,0,200,40)
        
        // 背景色を設定する.
        myButton3.backgroundColor = UIColor.blueColor()
        
        // 枠を丸くする.
        myButton3.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        myButton3.setTitle("Option", forState: UIControlState.Normal)
        myButton3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        myButton3.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
        myButton3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        // コーナーの半径を設定する.
        myButton3.layer.cornerRadius = 20.0
        
        myButton3.layer.position = CGPoint(x: self.view2.frame.width/2, y:500)
        
        // タグを設定する.
        myButton3.tag = 3
        
        // イベントを追加する.
        myButton3.addTarget(self, action: "onClickOption:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view2.addSubview(myButton3)
       
        
        //-------------------------swipe------------------------------------------------------------------
        
        myButton2 = UIButton()
        
        // サイズを設定する.
        myButton2.frame = CGRectMake(0,0,200,40)
        
        // 背景色を設定する.
        myButton2.backgroundColor = UIColor.blackColor()
        
        // 枠を丸くする.
        myButton2.layer.masksToBounds = true
        
        // タイトルを設定する(通常時).
        myButton2.setTitle("PlusAlbum", forState: UIControlState.Normal)
        myButton2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        myButton2.setTitle("ボタン(押された時)", forState: UIControlState.Highlighted)
        myButton2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        // コーナーの半径を設定する.
        myButton2.layer.cornerRadius = 20.0
        
        myButton2.layer.position = CGPoint(x: self.view2.frame.width/2, y:50)
        
        // タグを設定する.
        myButton2.tag = 2
        
        // イベントを追加する.
        myButton2.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // ボタンをViewに追加する.
        self.view2.addSubview(myButton2)
    /////////////////////////////////////////////////////////////////////////////////////////
        //上へのスワイプを定義
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        upSwipe.direction = .Up
        
        //下へのスワイプを定義
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        downSwipe.direction = .Down
        
        //leftSwipeで足す
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        //-------------------------swipe------------------------------------------------------------------
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //=========================Photo=================================================================
    
    func getAllPhoto(){
        
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
        }
        
        print("getAllPhoto読み込み終了")
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
        
        // １ページ単位でスクロールさせる
        scrollView.pagingEnabled = true
        
        //scroll画面の初期位置
        scrollView.contentOffset = CGPointMake(0, 0);
        
        for i in 0...2 {
            
            var x:CGFloat = 0
            let y:CGFloat = 0
            
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
        
        for (var i = 0;i < hennsuu; i++){
            let options = MDCSwipeToChooseViewOptions()
            options.delegate = self
            options.likedText = "Keep"
            options.likedColor = UIColor.blueColor()
            options.nopeText = "Delete"
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
                makeColectionViewBtn()
                return true; //NO
            } else if (shouldBeChosenWithDirection == MDCSwipeDirection.Right){
                print("Photo saved!")
                rightRead()
                makeColectionViewBtn()

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
    
    //=========================Collection=================================================================
    
    func makeCollectionView(sender: UIButton){
        
        readColloctionView() //画像の読み込み、UIImageの配列を作成
        imageCollectionViewAppear()
        
        // CollectionViewのレイアウトを生成.
        let layout = UICollectionViewFlowLayout()
        
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSizeMake(40 , 40)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSizeMake(100,30)

        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: CGRectMake(0, 0, view3.frame.width, view3.frame.height), collectionViewLayout: layout)
        
        print("layout")
        // Cellに使われるクラスを登録.
        myCollectionView.registerClass(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.backgroundColor = UIColor.clearColor()
        print("myCollectionView")
        
        self.view3.addSubview(myCollectionView)
        
         
    }
    
    func readColloctionView(){
            //Delegateを読み込む
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            //Entityの操作を制御するmanagedObjectContextをAppdelegateから作成する
            let managedObjectContext = appDelegate.managedObjectContext
            
            //Entityを設定
            let entityDiscription = NSEntityDescription.entityForName("Picture", inManagedObjectContext: managedObjectContext)
            
            let fetchRequest = NSFetchRequest(entityName: "Picture")
            fetchRequest.entity = entityDiscription
        
     
            
            do{
                let fetchResults = try managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
           
                //アルバムと同じ名前のキーのアルバムを取得
                let predicate = NSPredicate(format: "%K = %@", "album",albumCorrect)
                fetchRequest.predicate = predicate

                
                for managedObject in fetchResults!{
                    
                    if count2 == 10{
                    break
                    }
                    count2++
                    
                    let picture = managedObject as! Picture
                    print("Camera: \(picture.cameraroll), Album:\(picture.album)")
                    print("fetchResults?.count = \(fetchResults?.count)")//3016
                    ////////////////Keyがついたパスの取得をして、配列の中にいれる
                   
                        
                        let filePath: String = picture.cameraroll!
                        
                        let fileUrl = NSURL(string:filePath)
                        
                        //PHAssetUrl取得
                       PHCollecionViewAssetForFileURL(fileUrl!)
                }
                
                
            }catch{
                print("could not catch")
            }
        
    }
  

  //PHAssetURLを取得
    func PHCollecionViewAssetForFileURL(fileUrl: NSURL){
       
    var imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .Current
        imageRequestOptions.deliveryMode = .FastFormat
        imageRequestOptions.resizeMode = .Fast
        imageRequestOptions.synchronous = true
    
    
        
    let fetchResult = PHAsset.fetchAssetsWithOptions(nil)
        
    
    //////////////数を呼び込まれる回数に対して、同時に上がっていかないと、画像が変化しない
    
      photosCollectionView.append(fetchResult[count2] as! PHAsset)
    
     }

      func imageCollectionViewAppear() {
    //PHAssetをUIImageに変換して、画像の配列を作る
    
        for (var i = 0;i < hennsuu ; i++){
        
        
        let phimgr:PHImageManager = PHImageManager();
        phimgr.requestImageForAsset(photosCollectionView[i],
            targetSize: CGSize(width: 320, height: 320),
            contentMode: .AspectFill, options: nil) {
                image, info in
                //ここでUIImageを取得します。
                self.imageCollectionView.append(image!)  //UIImageを配列に取得する
                
           }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        // return myValue.count pickerの数の分だけ、アルバムを作る
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CustomCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("myCell", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        cell.imgView?.image = imageCollectionView[indexPath.row]
        print("indexPath.section = \(indexPath.row)")
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    
    
    //=========================Collection=============================================================

    
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
    
    //==================AlertView=============================================================
    func onClickMyButton(sender: UIButton) {
    
    // Alert生成.
    let myAlert: UIAlertController = UIAlertController(title: "Caution", message: "PlusAlbum", preferredStyle: UIAlertControllerStyle.Alert)
    
    // OKアクション生成.
    let OkAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action: UIAlertAction!) -> Void in
        for albumname in myAlert.textFields!{
             let text = albumname.text
             self.albumTinderAlbum(text!) //tinderalbumに画像を抽出
            print("text =  \(text)")
            
        }
    print("OK")
    }
    
    // Cancelアクション生成.
    let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (action: UIAlertAction!) -> Void in
    print("Cancel")
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
    
    /*
    pickerに表示する値を返すデリゲートメソッド.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myValues[row] as? String
    }
    
    
    /*
    pickerが選択された際に呼ばれるデリゲートメソッド.
    */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(myValues[row])")
        //タグ付け機能を使って、どうやって使い分けるか
        
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
        
        for (var i = 0;i < myValues.count; i++){
            
            myButton = UIButton()
            
            // サイズを設定する.
            //CGRectMake(x,次の始まる視点 y, 横の大きさ, たての大きさ)
            myButton.frame = CGRectMake(20, CGFloat(i * 120), 100, 100)
            
            // 背景色を設定する.
            myButton.backgroundColor = UIColor.blueColor()
            
            // 枠を丸くする.
            myButton.layer.masksToBounds = true
            
            // タイトルを設定する(通常時).
            
            albumCorrect = myValues[i]
            myButton.setTitle(albumCorrect, forState: UIControlState.Normal)
            
            myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            // タイトルを設定する(ボタンがハイライトされた時).
            myButton.setTitle("Album表示", forState: UIControlState.Highlighted)
            myButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            // コーナーの半径を設定する.
            myButton.layer.cornerRadius = 20.0
            
            // タグを設定する.
            myButton.tag = i
            
            // イベントを追加する.
            myButton.addTarget(self, action: "makeCollectionView:", forControlEvents: .TouchUpInside)
            
            // ボタンをViewに追加する.
            self.view3.addSubview(myButton)
            
        }

    }




}

