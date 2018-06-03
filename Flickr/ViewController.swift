//
//  ViewController.swift
//  Flickr
//
//  Created by Yu, Huiting on 3/16/18.
//  Copyright © 2018 Yu, Huiting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let flickerManager = FlickerManager.shared
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet fileprivate var searchBar: UISearchBar!
    fileprivate var urls: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        flickerManager.requestImages(keyword: searchText, resetPage: true) { [weak self] (urls, error) in
            guard let this = self else { return }
            guard let urls = urls, nil == error else { return }
            this.urls = urls
            this.collectionView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        urls = []
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCellReuseIdentifier", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(urls[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 10
        let width = (collectionView.frame.size.width - spacing * 4)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 1 && indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - 1, let text = searchBar.text {// last item
            flickerManager.requestImages(keyword: text, resetPage: false) { [weak self] (urls, error) in
                guard let this = self else { return }
                guard let urls = urls, nil == error else { return }
                this.urls.append(contentsOf: urls)
                this.collectionView.reloadData()
            }
        }
    }
    
    /*
    @available(iOS 6.0, *)
    optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    
    @available(iOS 6.0, *)
    optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    
    @available(iOS 6.0, *)
    optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    
    @available(iOS 6.0, *)
    optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    
    @available(iOS 6.0, *)
    optional public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
 */
}
