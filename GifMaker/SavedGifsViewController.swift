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
      collectionView.delegate = self
    }
  }
  
  @IBOutlet private weak var emptyView: UIStackView!
  let savedGifsURL = FileManager.documentsDirectory.appendingPathComponent("savedGifs").appendingPathExtension("json")
  
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
  
  private func fetchSavedGifsFromDisk() {
    do {
      let savedGifsData = try Data(contentsOf: savedGifsURL)
      savedGifs = try JSONDecoder().decode([Gif].self, from: savedGifsData)
    } catch (let error) {
      print("Unable to get data from url: \(savedGifsURL), error: \(error.localizedDescription)")
    }
  }
  
  private func persistGifsToDisk() {
    do {
      let jsonData = try JSONEncoder().encode(savedGifs)
      try jsonData.write(to: savedGifsURL)
    } catch(let error) {
      print("Unable to save gifs at url: \(savedGifsURL) error: \(error)")
    }
//    do {
//      let data = try NSKeyedArchiver.archivedData(withRootObject: gif, requiringSecureCoding: false)
//      try data.write(to: savedGifsURL)
//    } catch(let error) {
//      print("Unable to archive gif: \(error.localizedDescription)")
//    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchSavedGifsFromDisk()
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
    var newGif = gif
    newGif.gifData = try? Data(contentsOf: gif.gifURL)
    savedGifs.append(newGif)
    persistGifsToDisk()
    reloadData()
  }
}
