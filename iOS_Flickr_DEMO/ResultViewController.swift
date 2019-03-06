//
//  ViewController.swift
//  iOS_Flickr_DEMO
//
//  Created by Steven Zeng on 2019/3/5.
//  Copyright © 2019 ZengSQi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ResultViewController: UIViewController {
    
    var name:String = ""
    var page:Int = 1
    
    var datas:[Photo] = []
    
    var waiting = false
    var currentPage = 1
    
    var favPhotos: [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = name
        
        if let propertylistPhotos = UserDefaults.standard.array(forKey: "favPhotos") as? [[String:String]] {
            favPhotos = propertylistPhotos.compactMap{ Photo(dictionary: $0) }
        }
        
        self.collectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        print(name)
        print(page)
        
        let parameters: Parameters = [
            "method": "flickr.photos.search",
            "api_key": API_KEY,
            "per_page": page,
            "format": "json",
            "nojsoncallback": 1,
            "text": name
        ]
        
        Alamofire.request("https://api.flickr.com/services/rest/", method: .post, parameters: parameters).responseJSON { response in
            do{
                let json = try JSON(data: response.data!)
                print(json)
                self.datas = []
                for data in json["photos"]["photo"].arrayValue{
                    self.datas.append(Photo(id: data["id"].stringValue, name: data["title"].stringValue, imgUrl: "https://farm2.staticflickr.com/\(data["server"].stringValue)/\(data["id"].stringValue)_\(data["secret"].stringValue).jpg"))
                }
                print(self.datas)
                self.collectionView.reloadData()
            }catch {
                
            }
        }
    }
}

extension ResultViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        
        cell.name.text = datas[indexPath.row].name
        cell.photo.sd_setImage(with: URL(string: datas[indexPath.row].imgUrl), completed: nil)
        cell.view.backgroundColor = .red
        cell.name.textColor = .white
        return cell
    }
    
    
}

extension ResultViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = datas[indexPath.row].id
        let name = datas[indexPath.row].name
        let menu = UIAlertController(title: "我的最愛", message: name, preferredStyle: .actionSheet)
        let check = favPhotos.filter{$0.id == id}
        if check.count != 0{
            let action = UIAlertAction(title: "移除", style: .default) { (action) in
                self.favPhotos.removeAll(where: {$0.id == id})
                let propertylistPhotos = self.favPhotos.map{ $0.propertyListRepresentation }
                UserDefaults.standard.set(propertylistPhotos, forKey: "favPhotos")
                self.collectionView.reloadItems(at: [indexPath])
            }
            menu.addAction(action)
        }else{
            let action = UIAlertAction(title: "加入", style: .default) { (action) in
                self.favPhotos.append(self.datas[indexPath.row])
                let propertylistPhotos = self.favPhotos.map{ $0.propertyListRepresentation }
                UserDefaults.standard.set(propertylistPhotos, forKey: "favPhotos")
                self.collectionView.reloadItems(at: [indexPath])
            }
            menu.addAction(action)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        menu.addAction(cancel)
        self.present(menu, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= datas.count-2 && !self.waiting  {
            waiting = true;
            self.loadMoreData()
        }
    }
    
    func loadMoreData(){
        currentPage = currentPage + 1
        let parameters: Parameters = [
            "method": "flickr.photos.search",
            "api_key": API_KEY,
            "per_page": page,
            "page": self.currentPage,
            "format": "json",
            "nojsoncallback": 1,
            "text": name
        ]
        
        Alamofire.request("https://api.flickr.com/services/rest/", method: .post, parameters: parameters).responseJSON { response in
            do{
                let json = try JSON(data: response.data!)
                print(json)
                for data in json["photos"]["photo"].arrayValue{
                    self.datas.append(Photo(id: data["id"].stringValue, name: data["title"].stringValue, imgUrl: "https://farm2.staticflickr.com/\(data["server"].stringValue)/\(data["id"].stringValue)_\(data["secret"].stringValue).jpg"))
                }
                print(self.datas)
                self.collectionView.reloadData()
                self.waiting = false
            }catch {
                
            }
        }
    }
    
}

extension ResultViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 15, height: 140)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10
        )
    }
    
}

