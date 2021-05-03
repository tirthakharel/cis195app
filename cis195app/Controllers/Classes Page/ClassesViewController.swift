//
//  ClassesViewController.swift
//  cis195app
//

import UIKit
import FirebaseAuth

class ClassesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    var collectionView: UICollectionView?
    var currUser: FirebaseAuth.User?
    var classes: [UserClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        guard let collectionView = collectionView else {
            return
        }
        title = "Classes"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        let plusImg = UIImage(systemName: "plus.circle.fill")
        let button =  UIBarButtonItem(image: plusImg, style: .plain, target: self, action: #selector(addClass))
        button.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItem = button
        
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // cell
        collectionView.register(ClassCollectionViewCell.self, forCellWithReuseIdentifier: ClassCollectionViewCell.identifier)
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.75
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    
    private func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let size = (self.view.width - 80)/2
        layout.itemSize = CGSize(width: size, height: size)
        
        return layout
    }
    
    @objc private func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != .began){
            return
        }

        let p = gestureRecognizer.location(in: self.collectionView!)

        if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            let item = classes[indexPath.item]
            let alert = UIAlertController(title: "Delete", message: "You sure you want to delete this class?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                print("hello")
                if let userEmail = self.currUser?.email {
                    DBController.sharedDB.getUser(with: userEmail) { (user) in
                        if let usr = user {
                            DBController.sharedDB.removeClass(with: usr, with: item) { (newClassList) in
                                self.classes = newClassList
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }
                        }
                    }
                }
            }))
            present(alert, animated: true)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userEmail = self.currUser?.email {
            DBController.sharedDB.getUser(with: userEmail) { (user) in
                if let usr = user {
                    DBController.sharedDB.getClasses(with: usr) { (classList) in
                        self.classes = classList
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func addClass() {
        let vc = NewClassViewController()
        vc.currUser = self.currUser
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ClassesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let classItem = classes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassCollectionViewCell.identifier, for: indexPath) as! ClassCollectionViewCell
        cell.classLabel.text = classItem.className
        cell.numAssignments.text = "\(classItem.assignments.count)"
        cell.contentView.backgroundColor = classItem.bgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let classItem = classes[indexPath.item]
        let vc = ClassPageViewController()
        vc.currClass = classItem
        vc.currUser = currUser
        vc.title = classItem.className
        let navView = UINavigationController(rootViewController: vc)
        navView.modalTransitionStyle = .coverVertical
        navView.modalPresentationStyle = .fullScreen
        navView.navigationBar.prefersLargeTitles = true
        DispatchQueue.main.async {
            self.present(navView, animated: true)
        }
    }
    
}
