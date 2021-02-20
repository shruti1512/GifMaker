//
//  SavedGifsViewController.swift
//  GifMaker
//
//  Created by Shruti Sharma on 2/18/21.
//  Copyright © 2021 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var collectionView: UICollectionView! {
    didSet {
      collectionView.collectionViewLayout = configureCollectionViewLayout()
      collectionView.backgroundColor = .systemBackground
      collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
      collectionView.delegate = self
    }
  }
  @IBOutlet private weak var emptyView: UIStackView!

  // MARK: - Instance Properties
  
  let userDefaults = UserDefaults.standard
  let savedGifsURL = FileManager.documentsDirectory
                    .appendingPathComponent("savedGifs")
                    .appendingPathExtension("json")
  private enum Section {
    case main
  }
  private typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<Section, Gif>
  private var dataSource: CollectionViewDataSource!
  private var savedGifs: [Gif] = [] {
    didSet {
      emptyView.isHidden = (savedGifs.count != 0)
      navigationController?.navigationBar.isHidden = (savedGifs.count == 0)
    }
  }

  // MARK: - View Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    showWelcome()
    fetchSavedGifsFromDisk()
    configureDataSource()
    reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    title = "My Collection"
    userDefaults.set(true, forKey: "WelcomeScreen")
    navigationController?.navigationBar.isHidden = (savedGifs.count == 0)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    title = ""
    navigationController?.navigationBar.isHidden = false
  }

  // MARK: - Show Welcome Screen

  private func showWelcome()  {
    if !userDefaults.bool(forKey: "WelcomeScreen") {
      guard let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController else { return }
      present(welcomeVC, animated: true)
    }
  }
  
  // MARK: - Persist and load gifs in and from disk

  private func persistGifsToDisk() {
    do {
      let jsonData = try JSONEncoder().encode(savedGifs)
      try jsonData.write(to: savedGifsURL)
    } catch(let error) {
      print("Unable to save gifs at url: \(savedGifsURL) error: \(error)")
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
    
  // MARK: - Configure CollectionView Compositional Layout

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
  
  // MARK: - Configure CollectionView Diffable DataSource

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
  
  // MARK: - Apply DataSnapshot To Diffable DataSource

  private func reloadData() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Gif>()
    snapshot.appendSections([.main])
    snapshot.appendItems(savedGifs)
    dataSource.apply(snapshot)
  }
  
}

// MARK: - PreviewViewControllerDelegate

extension SavedGifsViewController: PreviewViewControllerDelegate {
  
  public func previewViewController(_ previewVC: GifPreviewViewController, didSaveGif gif: Gif) {
    var newGif = gif
    newGif.gifData = try? Data(contentsOf: gif.gifURL)
    savedGifs.append(newGif)
    persistGifsToDisk()
    reloadData()
  }
}

// MARK: - UICollectionViewDelegate

extension SavedGifsViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "GifDetailViewController") as? GifDetailViewController else { return }
    detailVC.gif = dataSource.itemIdentifier(for: indexPath)
    detailVC.modalPresentationStyle = .currentContext
    present(detailVC, animated: true)
  }
}

