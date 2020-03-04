//
//  MainController.swift
//  Exo-FacebookSwiftUI
//
//  Created by Salim SAÏD on 03/02/2020.
//  Copyright © 2020 Salim SAÏD. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class PostCell: LBTAListCell<String> {
    let imageView = UIImageView(backgroundColor: .purple)
    let nameLabel = UILabel(text: "Name label")
    let dateLabel = UILabel(text: "Thursday at 12:35pm")
    let postLabel = UILabel(text: "This is my first post !!")
//    let viewGrid = UIView(backgroundColor: .blue)
    let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        
        stack(hstack(imageView.withHeight(45).withWidth(45), stack(nameLabel, dateLabel), spacing: 9).padLeft(12).padRight(12).padTop(12),
              postLabel,
              photosGridController.view, spacing: 9).padLeft(5).padRight(5)
    }
}

class StoryHeader: UICollectionReusableView, UICollectionViewDelegateFlowLayout {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class StoryPhotoCell: LBTAListCell<String> {
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "My name", font: .boldSystemFont(ofSize: 15), textColor: .white)
    let gradientLayer = CAGradientLayer()
    
    override var item: String! {
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    override func setupViews() {
        backgroundColor = .red
        imageView.layer.cornerRadius = 15
        
        stack(imageView)
        setupGradientLayer()
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.8, 1.1]
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }
}

class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["avatar1", "avatar1"]
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
}

class MainController: LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout {
    
    let fbLogo = UIImageView(image: UIImage(named: "fbLogo"), contentMode: .scaleAspectFit)
    lazy var searchButton = UIButton(image: UIImage(named: "search")!, tintColor: .black)
    lazy var messengerButton = UIButton(image: UIImage(named: "messenger")!, tintColor: .black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .blue
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        setupNavBar()
        self.items = ["Hello", "World", "Yeah!!", "New friend"]
    }
    
    // Facebook navigation bar
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topSafeArea = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let offset = scrollView.contentOffset.y + topSafeArea + (navigationController?.navigationBar.frame.height ?? 0)
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        let alpha: CGFloat = 1 - (offset / topSafeArea)
        
        [fbLogo, searchButton, messengerButton].forEach{$0.alpha = alpha}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    // PhotoGridController height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 423)
    }
    
    fileprivate func setupNavBar() {
        let coverWhiteView = UIView(backgroundColor: .white)
        view.addSubview(coverWhiteView)
        coverWhiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        let topSafeArea = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        
        coverWhiteView.constrainHeight(topSafeArea)
        
        [searchButton, messengerButton].forEach { (button) in
            button.layer.cornerRadius = 17
            button.clipsToBounds = true
            button.backgroundColor = .init(white: 0.9, alpha: 1)
            button.withSize(.init(width: 34, height: 34))
        }
        
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        let lessWidth: CGFloat = 120 + 34 + 34 + 24 + 16
        let width = (view.frame.width - lessWidth)
        let titleView = UIView()
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
        titleView.hstack(fbLogo.withWidth(120), UIView().withWidth(width), searchButton, messengerButton, spacing: 8).padBottom(8)
        navigationItem.titleView = titleView
    }
}


struct MainPreview: PreviewProvider {
    static var previews: some View {
//        Text("Some text")
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
}
