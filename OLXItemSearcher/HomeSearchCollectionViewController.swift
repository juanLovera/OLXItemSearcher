//
//  HomeSearchCollectionViewController.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/8/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit
import Haneke

class HomeSearchCollectionViewController: UICollectionViewController {
  
  private let reuseIdentifier = "itemCell"
  private let nibCellName = "ItemCollectionCell"
  private var currentlyFetching = false
  private var currentSearchHasNoMoreResults = false
  private let searchBar = UISearchBar()
  private var loadedItems: [Item] = []
  private let requestQueue = DispatchQueue(label: "com.juanlovera.requestQueue", attributes: .concurrent)
  private var refreshControl = UIRefreshControl()
  
  @IBOutlet weak var noResultsLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    prepareUI()
    addObservers()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  func newFetchForItems(term: String) {
    currentSearchHasNoMoreResults = false
    currentlyFetching = true
    let fetchingService = FetchPublicItemsService(searchTerm: term, offset: 0, responseCallback: showNewItems)
    fetchingService.makeRequest()
  }
  
  func fetchMoreItems() {
    if (currentlyFetching || currentSearchHasNoMoreResults) {
      return
    }
    currentlyFetching = true
    let fetchingService = FetchPublicItemsService(searchTerm: searchBar.text!, offset: loadedItems.count, responseCallback: showMoreItems)
    fetchingService.makeRequest()
  }
  
  func showNewItems(items: [Item]) {
    loadedItems = items
    showNoResultsLabelIfApply()
    collectionView?.reloadData()
    collectionView?.scrollToTop()
    currentlyFetching = false
  }
  
  func showMoreItems(items: [Item]) {
    if items.count == 0 {
      currentSearchHasNoMoreResults = true
      return
    }
    let oldItemsCount = loadedItems.count
    loadedItems.append(contentsOf: items)
    var newIndexPaths: [IndexPath] = []
    for index in oldItemsCount...loadedItems.count - 1 {
      newIndexPaths.append(IndexPath(row: index, section: 0))
    }
    collectionView?.insertItems(at: newIndexPaths)
    currentlyFetching = false
  }
  
  func deviceDidRotate() {
    // This is to refresh cells per line with new orientation
    let collectionViewLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    collectionViewLayout.invalidateLayout()
  }
  
  func itemDidChange(notification: Notification) {
    if let itemID = notification.object as? Int64 {
      if let indexForItem = loadedItems.index(where: { $0.id == itemID }) {
        let indexPath = IndexPath(row: indexForItem, section: 0)
        collectionView?.reloadItems(at: [indexPath])
      }
    }
  }
  
  func likeButtonPressed(button: UIButton) {
    if let touchPoint = collectionView?.convert(CGPoint.zero, from: button) {
      if let tapIndexPath = collectionView?.indexPathForItem(at: touchPoint) {
        let item = loadedItems[tapIndexPath.row]
        if !FavoriteManager.isItemOnFavorites(item: item) {
          addToFavoritesItem(at: tapIndexPath)
        } else {
          deleteFromFavoritesItem(at: tapIndexPath)
        }
      }
    }
  }
  
  func startRefreshing() {
    newFetchForItems(term: searchBar.text!)
    refreshControl.endRefreshing()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? ItemDetailViewController {
      if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?[0] {
        destinationViewController.item = loadedItems[(selectedIndexPath.row)]
      }
    }
  }
  
  private func addToFavoritesItem(at indexPath: IndexPath) {
    let item = loadedItems[indexPath.row]
    _ = FavoriteManager.addItemToFavorites(item: item)
  }
  
  private func deleteFromFavoritesItem(at indexPath: IndexPath) {
    let item = loadedItems[indexPath.row]
    _ = FavoriteManager.deleteItemFromFavorites(item: item)
  }
  
  private func prepareUI() {
    addSearchBarToNavBar()
    makeInitialGenericFetch()
    addPullToRefresh()
    let nibName = UINib(nibName: nibCellName, bundle:nil)
    collectionView?.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func addSearchBarToNavBar() {
    searchBar.placeholder = Literals.searchForItems
    searchBar.delegate = self
    searchBar.setBackgroundColor(color: Config.SearchBarStyle.background)
    searchBar.setTextColor(color: UIColor.white)
    searchBar.setPlaceholderTextColor(color: UIColor.white)
    searchBar.setSearchImageColor(color: UIColor.white)
    searchBar.setImage(UIImage(named: Literals.ImageNames.clearButton), for: .clear, state: .normal)
    UISearchBar.appearance().tintColor = UIColor.white
    navigationItem.titleView = searchBar
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(itemDidChange), name: Literals.Observers.itemDidChange, object: nil)
  }
  
  private func showNoResultsLabelIfApply() {
    if loadedItems.count == 0 {
      noResultsLabel.isHidden = false
    } else {
      noResultsLabel.isHidden = true
    }
  }
  
  private func makeInitialGenericFetch() {
    newFetchForItems(term: "")
  }
  
  private func addPullToRefresh() {
    refreshControl.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
    collectionView?.addSubview(refreshControl)
    collectionView?.alwaysBounceVertical = true
  }
  
  // MARK: Collection view datasource and delegate methods
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return loadedItems.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionCell
    let item = loadedItems[indexPath.row]
    ItemCollectionCell.populateCell(cell: cell, item: item)
    cell.likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    return cell
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if !currentlyFetching && scrollView.isFullyScrolled() {
      requestQueue.sync {
        fetchMoreItems()
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: Literals.Segues.itemDetail, sender: self)
  }
  
}

extension HomeSearchCollectionViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    var cellsSize = Config.CollectionViews.defaultCellSize
    let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let sectionMargin = collectionViewLayout.sectionInset.left
    let cellSpacing = collectionViewLayout.minimumInteritemSpacing / 2
    var numberOfItemsPerLine = CGFloat(Config.CollectionViews.cellsPerLineInPortrait)
    if UIApplication.shared.statusBarOrientation.isLandscape {
      numberOfItemsPerLine = CGFloat(Config.CollectionViews.cellsPerLineInLandscape)
    }
    cellsSize.width = (view.frame.width / numberOfItemsPerLine) - sectionMargin - cellSpacing
    return cellsSize
  }
  
}

extension HomeSearchCollectionViewController : UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    newFetchForItems(term: searchBar.text!)
    searchBar.resignFirstResponder()
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    newFetchForItems(term: searchBar.text!)
    searchBar.resignFirstResponder()
  }
  
}
