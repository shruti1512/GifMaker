//
//  SavedGifsViewController.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/18/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController {
  
  enum Section {
    case main
  }
  
  typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, Gif>
  var dataSource: CollectionViewDataSource!
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: configureCollectionViewLayout())
    collectionView.backgroundColor = .systemBackground
    collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
    //    collectionView.dataSource = configureDataSource()
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(0.5))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func configureDataSource()  {
    dataSource = CollectionViewDataSource(collectionView: collectionView) {
      (collectionView, indexPath, gif) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.reuseIdentifier,
                                                          for: indexPath) as? GifCell else {
        fatalError("Unable to deque cell with reuseIdentifier: \(GifCell.reuseIdentifier)")
      }
      cell.configure(with: gif)
      return cell
    }
  }
  
}
