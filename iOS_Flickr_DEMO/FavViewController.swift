//
//  FavViewController.swift
//  iOS_Flickr_DEMO
//
//  Created by Steven Zeng on 2019/3/5.
//  Copyright © 2019 ZengSQi. All rights reserved.
//

import UIKit

class FavViewController: UIViewController {

    var favPhotos: [Photo] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let propertylistPhotos = UserDefaults.standard.array(forKey: "favPhotos") as? [[String:String]] {
            favPhotos = propertylistPhotos.compactMap{ Photo(dictionary: $0) }
        }
        
        self.collectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        self.collectionView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let propertylistPhotos = UserDefaults.standard.array(forKey: "favPhotos") as? [[String:String]] {
            favPhotos = propertylistPhotos.compactMap{ Photo(dictionary: $0) }
        }
        self.collectionView.reloadData()
    }

}

extension FavViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favPhotos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        
        cell.name.text = favPhotos[indexPath.row].name
        cell.photo.sd_setImage(with: URL(string: favPhotos[indexPath.row].imgUrl), completed: nil)
        let check = favPhotos.filter{$0.id == favPhotos[indexPath.row].id}
        if check.count != 0{
            cell.view.backgroundColor = .red
            cell.name.textColor = .white
        }else{
            cell.view.backgroundColor = .groupTableViewBackground
            cell.name.textColor = .darkText
        }
        return cell
    }
    
    
}

extension FavViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = favPhotos[indexPath.row].id
        let name = favPhotos[indexPath.row].name
        let menu = UIAlertController(title: "我的最愛", message: name, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "移除", style: .default) { (action) in
            self.favPhotos.removeAll(where: {$0.id == id})
            let propertylistPhotos = self.favPhotos.map{ $0.propertyListRepresentation }
            UserDefaults.standard.set(propertylistPhotos, forKey: "favPhotos")
            self.collectionView.reloadData()
            }
        menu.addAction(action)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        menu.addAction(cancel)
        self.present(menu, animated: true, completion: nil)
    }
    
}

extension FavViewController: UICollectionViewDelegateFlowLayout{
    
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

