//
//  HomeViewController.swift
//  cis195app
//
//  The main view of the application
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = createLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.backgroundColor = .white
        
        collectionView.register(ToDoCollectionViewCell.self, forCellWithReuseIdentifier: ToDoCollectionViewCell.identifier)
        collectionView.register(ClassesCollectionViewCell.self, forCellWithReuseIdentifier: ClassesCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAuthenticated()
    }
    
    // MARK: - Functions
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(2/5)),
            subitem: item,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func isAuthenticated() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navView = UINavigationController(rootViewController: vc)
            navView.modalPresentationStyle = .fullScreen
            present(navView, animated: false)
        } else {
            //print("USER: \(FirebaseAuth.Auth.auth().currentUser)")
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if (indexPath.item == 0) {
//            let toDoCell = collectionView.dequeueConfiguredReusableCell(using: UICollectionView.CellRegistration<Cell, Item>, for: <#T##IndexPath#>, item: <#T##Item?#>)
//
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .blue
        return cell
    }
}

