//
//  SavedGifsViewController.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/18/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController {
  
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView.collectionViewLayout = configureCollectionViewLayout()
      collectionView.backgroundColor = .systemBackground
      collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
    }
  }
  
  @IBOutlet private weak var emptyView: UIStackView!

  private enum Section {
    case main
  }
  
  private typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, Gif>
  private var dataSource: CollectionViewDataSource!
  private var savedGifs: [Gif] = [] {
    didSet {
      emptyView.isHidden = (savedGifs.count != 0)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()
    reloadData()
  }
  
  private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .fractionalWidth(0.5))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func configureDataSource() {
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
  
  private func reloadData() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Gif>()
    snapshot.appendSections([.main])
    snapshot.appendItems(savedGifs)
    dataSource.apply(snapshot)
  }
}

extension SavedGifsViewController: PreviewViewControllerDelegate {
  
  public func previewViewController(_ previewVC: GifPreviewViewController, didSaveGif gif: Gif) {
    guard let url = gif.gifURL else { return }
    var newGif = gif
    newGif.gifData = try? Data(contentsOf: url)
    savedGifs.append(gif)
    reloadData()
  }
}
