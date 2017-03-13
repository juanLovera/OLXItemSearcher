//
//  LikesCollectionViewController.swift
//  OLXItemSearcher
//
//  Created by Juan José Lovera Brito on 3/10/17.
//  Copyright © 2017 Juan José Lovera. All rights reserved.
//

import UIKit
import CoreData

class LikesCollectionViewController: UICollectionViewController {
  
  private let reuseIdentifier = "itemCell"
  private let nibCellName = "ItemCollectionCell"
  
  @IBOutlet weak var noLikesLabel: UILabel!
  
  static let delegate = UIApplication.shared.delegate as! AppDelegate
  static let managedObjectContext = delegate.managedObjectContext
  var blockOperations: [BlockOperation] = []
  
  lazy var fetchedResultsController: NSFetchedResultsController<ItemPersistent> = {
    let fetchRequest: NSFetchRequest<ItemPersistent> = ItemPersistent.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: Entity.ItemPersistent.likedDate, ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    startFetchResultsController()
    prepareUI()
    addObservers()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let collectionViewLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    collectionViewLayout.invalidateLayout()
  }
  
  deinit {
    // Cancels all block operations
    for operation: BlockOperation in blockOperations {
      operation.cancel()
    }
    blockOperations.removeAll(keepingCapacity: false)
    NotificationCenter.default.removeObserver(self)
  }
  
  func deviceDidRotate() {
    // This is to refresh cells per line with new orientation
    let collectionViewLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    collectionViewLayout.invalidateLayout()
  }
  
  func dislikeButtonPressed(button: UIButton) {
    if let touchPoint = collectionView?.convert(CGPoint.zero, from: button) {
      if let tapIndexPath = collectionView?.indexPathForItem(at: touchPoint) {
        deleteFromFavoritesItem(at: tapIndexPath)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destinationViewController = segue.destination as? ItemDetailViewController {
      if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?[0] {
        let itemPersistent = fetchedResultsController.object(at: selectedIndexPath)
        destinationViewController.item = itemPersistent.convertToNonPersistent()
        if let imageData = itemPersistent.fullImageData {
          let image = UIImage(data: imageData as Data)
          destinationViewController.itemPicture = image
        }
      }
    }
  }
  
  private func deleteFromFavoritesItem(at indexPath: IndexPath) {
    let alert = UIAlertController(title: Literals.dislikeItemConfirmMessage, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: Literals.cancelButton, style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: Literals.deleteButton, style: .destructive, handler: { _ in
      let item = self.fetchedResultsController.object(at: indexPath)
      if let cell = self.collectionView?.cellForItem(at: indexPath) as? ItemCollectionCell {
        if FavoriteManager.deleteItemFromFavorites(item: item) {
          cell.putLikeButton()
        }
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  }
  
  private func prepareUI() {
    let nibName = UINib(nibName: nibCellName, bundle:nil)
    collectionView?.register(nibName, forCellWithReuseIdentifier: reuseIdentifier)
    showNoLikesLabelIfApply()
  }
  
  private func startFetchResultsController() {
    do {
      try fetchedResultsController.performFetch()
    } catch let error {
      print(error)
    }
  }
  
  fileprivate func showNoLikesLabelIfApply() {
    if collectionView?.numberOfItems(inSection: 0) == 0 {
      noLikesLabel.isHidden = false
    } else {
      noLikesLabel.isHidden = true
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: Collection view datasource and delegate methods
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let sections = fetchedResultsController.sections {
      let currentSection = sections[section]
      return currentSection.numberOfObjects
    }
    return 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionCell
    let item = fetchedResultsController.object(at: indexPath)
    ItemCollectionCell.populateCell(cell: cell, item: item)
    cell.likeButton.addTarget(self, action: #selector(dislikeButtonPressed), for: .touchUpInside)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: Literals.Segues.itemDetail, sender: self)
  }
  
}

extension LikesCollectionViewController : UICollectionViewDelegateFlowLayout {
  
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

extension LikesCollectionViewController : NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    blockOperations.removeAll(keepingCapacity: false)
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    if type == NSFetchedResultsChangeType.insert {
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let this = self {
            this.collectionView!.insertItems(at: [newIndexPath!])
          }
          })
      )
    }
    else if type == NSFetchedResultsChangeType.update {
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let this = self {
            this.collectionView!.reloadItems(at: [indexPath!])
          }
          })
      )
    }
    else if type == NSFetchedResultsChangeType.move {
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let this = self {
            this.collectionView!.moveItem(at: indexPath!, to: newIndexPath!)
          }
          })
      )
    }
    else if type == NSFetchedResultsChangeType.delete {
      blockOperations.append(
        BlockOperation(block: { [weak self] in
          if let this = self {
            this.collectionView!.deleteItems(at: [indexPath!])
          }
          })
      )
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    collectionView!.performBatchUpdates({ () -> Void in
      for operation: BlockOperation in self.blockOperations {
        operation.start()
      }
      }, completion: { (finished) -> Void in
        self.blockOperations.removeAll(keepingCapacity: false)
        self.showNoLikesLabelIfApply()
    })
  }
}
