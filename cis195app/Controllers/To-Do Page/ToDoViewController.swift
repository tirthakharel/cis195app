//
//  ToDoViewController.swift
//  cis195app
//

import UIKit

class ToDoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        title = "To-Dos"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissSelf))
        
        collectionView.backgroundColor = .yellow
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let size = (self.view.width - 80)/2
        layout.itemSize = CGSize(width: size, height: size)
        
        return layout
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

}

extension ToDoViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    }
    
}
