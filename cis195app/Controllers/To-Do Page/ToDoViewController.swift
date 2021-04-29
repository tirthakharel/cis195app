//
//  ToDoViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class ToDoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView?
    var currUser: FirebaseAuth.User?
    var toDoItems: [ToDo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        title = "To-Dos"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        let plusImg = UIImage(systemName: "plus.square")?.withTintColor(.systemBlue)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: plusImg, style: .plain, target: self, action: #selector(addToDo))
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        // cell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(ToDoReusableCollectionViewCell.self, forCellWithReuseIdentifier: ToDoReusableCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.getToDos(with: usr) { (toDoList) in
                        self.toDoItems = toDoList
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }

    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addToDo() {
        print("ToDo: need to add functionality")
    }

}

extension ToDoViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoReusableCollectionViewCell.identifier, for: indexPath) as! ToDoReusableCollectionViewCell
        cell.taskLabel.text = toDoItems[indexPath.item].taskName
        cell.priorityLabel.text = toDoItems[indexPath.item].priorityString
        cell.priorityLabel.textColor = toDoItems[indexPath.item].priorityColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width - 45, height: collectionView.height / 10)
    }
}
