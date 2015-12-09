//
//  ThirdViewController.swift
//  Picture
//
//  Created by tamura seiya on 2015/12/06.
//  Copyright © 2015年 Seiya Tamura. All rights reserved.
//

import UIKit
import Photos
import CoreData

class ThirdViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myCollectionView : UICollectionView!
    var number:UInt32!
    
    var hennsuu = 10
    var count2 = 0
    var albumCorrect3:String!
    var photosCollectionView: [PHAsset] = []
    
    var imageCollectionView:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ThirdViewController")
        
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
        appDelegate.albumCorrect = albumCorrect3
//        print(albumCorrect3)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 3.0
        layout.minimumLineSpacing = 5.0
        layout.itemSize = CGSizeMake(self.view.frame.width / 2 - 10, self.view.frame.height / 3 - 10)
        
        ////////////////////////////////////////////
        readColloctionView()
        imageCollectionViewAppear()
        ////////////////////////////////////////////
        
        // CollectionViewを生成.
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        // Cellに使われるクラスを登録.
        myCollectionView.registerClass(CustomCollectionTableViewCell.self, forCellWithReuseIdentifier: "MyCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        self.view.addSubview(myCollectionView)
        
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
//            let predicate = NSPredicate(format: "%K = %@", "album",albumCorrect3)
//            fetchRequest.predicate = predicate
            
            
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

    
    
    /*
    Cellが選択された際に呼び出される
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Num: \(indexPath.row)")
        print("Value:\(collectionView)")
        
    }
    
    /*
    Cellの総数を返す
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionView.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell : CustomCollectionTableViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell",
            forIndexPath: indexPath) as! CustomCollectionTableViewCell

        // imabeviewを生成 (cgrectmakeで位置とサイズを指定するときにcellを親に考える)
        
        
        
        cell.imgView?.image = imageCollectionView[indexPath.row]
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    
}