//
//  HomeViewController.swift
//  FlickerPhotosSearch
//
//  Created by D MacBook Pro on 12/08/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    // Collection View
    var collectionView: UICollectionView?
    fileprivate let sectionInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    // Search Bar
    var searchBar: UISearchBar?
    var parentViewForSearchBar : UIView?
    
    // Activity Indicator
    var activityIndicator: ActivityIndicator? = ActivityIndicator()
    
    // View model and Data Source
    private var photosViewModel : HomePhotosViewModel!
    private var dataSource : HomePhotosDataSource<HomePhotosCell, PhotoModel>!

    // Others
    var selectedPhotoModel : PhotoModel?
    var selectedPhoto : UIImage?
      
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(savePhotosInDirectory))
        self.navigationItem.rightBarButtonItem  = saveButton
        self.navigationItem.title = "Flickr Photos"
        
        configSubviews()
        layoutUIConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViewModel(searchText: searchBar?.text ?? Constants.defaultFlickerSearch)
    }
    
    // MARK: - Initial Setup
    func configSubviews() {
        
        // UISearchBar
        parentViewForSearchBar = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 8*8))
        self.view.addSubview(parentViewForSearchBar!)
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: parentViewForSearchBar!.bounds.width, height: parentViewForSearchBar!.bounds.height))
        searchBar?.delegate = self
        searchBar?.text = Constants.defaultFlickerSearch
        parentViewForSearchBar?.addSubview(searchBar!)
        
        // UICollectionView
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView?.delegate = self
        collectionView?.register(HomePhotosCell.self, forCellWithReuseIdentifier: Constants.photosCellID)
        self.view.addSubview(collectionView!)
        setupCollectionView()
        
        // Activity Indicator
        self.activityIndicator?.parentView = collectionView!
    }
    
    // MARK: - Layout UI
    func layoutUIConstraints() {
        
        // Search Bar
        parentViewForSearchBar?.translatesAutoresizingMaskIntoConstraints = false
        parentViewForSearchBar?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        parentViewForSearchBar?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        parentViewForSearchBar?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        let heightConstraint = NSLayoutConstraint(item: parentViewForSearchBar!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 8*8)
        NSLayoutConstraint.activate([heightConstraint])
        
        // Collection View
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: parentViewForSearchBar!.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        collectionView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    // MARK: - View Model & Data Source
    func setupViewModel(searchText: String) {
        self.activityIndicator?.show(inView: self.collectionView!)
        
        // Initiate View Model
        self.photosViewModel = HomePhotosViewModel(searchText: searchText)
        
        // Call once didSet saved photos in PhotoModel and/or didSet Flicker API results in PhotoModel
        self.photosViewModel.bindPhotosDataToVC = {
            self.updatePhotosDataSource()
                                    
            if let error = self.photosViewModel.apiError, error != "" {
                CommonUtilities.showAlert(title: TitlesMessages.failed, message: error, controller: self)
            }
        }
    }
    
    func updatePhotosDataSource() {
        
        // Preparing data source for the collectionView
        if self.selectedPhotoModel != nil {
            self.dataSource =
            HomePhotosDataSource(items: self.photosViewModel.photosData, selectedPhotoModel: self.selectedPhotoModel!, configureCell: { (cell, data) in
                cell.photoValue = data
            })
        } else {
            self.dataSource =
            HomePhotosDataSource(items: self.photosViewModel.photosData, configureCell: { (cell, data) in
                cell.photoValue = data
            })
        }
        
        // Update UI
        DispatchQueue.main.async {
            // Stop in main thread
            self.activityIndicator?.stop()

            // Now, Flicker Photos is served in collectionView
            self.collectionView?.dataSource = self.dataSource
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - Save Photos Methods
    
    @objc func savePhotosInDirectory() {
        
        if let photoModel = self.selectedPhotoModel, let image = selectedPhoto {
            if let photoID = photoModel.id {
                
                // Apply Flicker Photo ID as file name for saving image.
                let fileName = photoID + ".jpg"
                let results = CommonUtilities.savePhotoToDirectory(image: image, imageName: fileName)
                
                CommonUtilities.showAlertWithDismissHandler(title: TitlesMessages.success, message: results.message, controller: self) { (ok) in
                    
                    // TODO: Should not call view model. Find easy way to update photoModel.
                    self.selectedPhotoModel = nil
                    self.setupViewModel(searchText: self.searchBar?.text ?? Constants.defaultFlickerSearch)

                }
            } else {
                CommonUtilities.showAlert(title: TitlesMessages.failed, message: "Flicker Photo ID is missing. Cannot save the image.", controller: self)
            }
        } else {
            CommonUtilities.showAlert(title: TitlesMessages.warning, message: "Please select a photo to save.", controller: self)
        }
        
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsHorizontalScrollIndicator = false
        
        guard let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView?.collectionViewLayout = layout
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check whether selected image is showing from directory or Flicker
        // If directory then don't do anything.
        // If Flicker then highlight the cell by saving model in one variable
        // And call the DataSource to update the collectionView.
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomePhotosCell
        selectedPhoto = cell.photoImageView.image
        
        let photoModel = self.photosViewModel.photosData[indexPath.row]
        if photoModel.isSavedPhoto == nil {
            self.selectedPhotoModel = photoModel
            
            self.updatePhotosDataSource()
        } else {
            CommonUtilities.showAlert(title: TitlesMessages.notice, message: "This photo is already saved in app directory.", controller: self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculation for showing 3 images in a row
        let paddingSpace = sectionInsets.left * itemsPerRow
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
