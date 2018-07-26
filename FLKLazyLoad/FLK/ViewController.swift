//
//  ViewController.swift
//  FLK
//
//  Created by Yu, Huiting on 6/8/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct player {
        var score: Int = 0
        var health: Int = 0
        
    }
    
    
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private let searchManager = SearchManager()
    
    private var photos = [Photo]()
    private var selectedPhoto: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        var p = player()
        balance(&p.score, &p.health)

        
    }
    
    
    func balance(_ v1: inout Int, _ v2: inout Int) {
        print(v1, v2)
        v1 = v1 + 1
        v2 = v2 + 1
        print(v1,v2)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoDetailsSegueIdentifier", let vc = segue.destination as? PhotoViewController, let p = selectedPhoto {
            vc.url = p.url
        }
    }

    //TODO: as the view controller gets larger, the searching logic could be moved into another 'Coordinator' object that owns the business logic of the VC.
    private func requestForPhotos(reset: Bool) {
        guard let searchText = searchBar.text else { return }
        searchManager.request(keyword: searchText, resetPage: reset) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let photos):
                if reset {
                    this.photos = photos
                } else {
                    this.photos.append(contentsOf: photos)
                }
                this.collectionView.reloadData()
            case .failure(let err):
                //TODO showing apporpriate UI according to error
                print(err)
            }
        }
    }
    
    func loadVisibleCells() {
        let cells = collectionView.visibleCells
        cells.forEach { ($0 as? PhotoCollectionViewCell)?.reloadImage() }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            photos = []
            collectionView.reloadData()
            return
        }
        requestForPhotos(reset: true)
    }
}
extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        let shouldLoad = !collectionView.isDragging && !collectionView.isTracking
        cell.configure(url: photos[indexPath.item].url, shouldLoad: shouldLoad)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension ViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("\(#function)")
        let delta = collectionView.contentSize.height - collectionView.contentOffset.y - collectionView.frame.size.height
        if delta < 80 {
            requestForPhotos(reset: false)
        }
        self.loadVisibleCells()
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("\(#function)")
        self.loadVisibleCells()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhoto = photos[indexPath.item]
        self.performSegue(withIdentifier: "showPhotoDetailsSegueIdentifier", sender: nil)
    }
}


