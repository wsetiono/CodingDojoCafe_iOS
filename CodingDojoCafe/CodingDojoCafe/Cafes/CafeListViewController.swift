//
//  CafeListViewController.swift
//  CodingDojoCafe
//
//  Created by William on 11/05/20.
//  Copyright © 2020 CodingDojo. All rights reserved.
//

import UIKit

class CafeListViewController: UIViewController, UICollectionViewDelegate {
    
    var manager = CafeDataManager()
    var selectedCafe:CafeItem?
    var selectedCity:LocationItem?
    var selectedType:String?

    @IBOutlet weak var collectionView:UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segue.showDetail.rawValue:
                showCafeDetail(segue:segue)
            default:
                print("Segue not added")
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {

//        super.viewDidAppear(animated)
//        guard let location = selectedCity?.city, let type = selectedType
//            else { return }
//        print("type \(type)")
//        print(CafeAPIManager.loadJSON(file: location))

        super.viewDidAppear(animated)
        createData()

        setupTitle()

    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: Private Extension
private extension CafeListViewController {
    // code goes here
    func createData() {
        guard let location = selectedCity?.city,
            let filter = selectedType else { return }
        manager.fetch(by: location, with: filter) { _ in
            if manager.numberOfItems() > 0 {
                collectionView.backgroundView = nil
            } else {
                let view = NoDataView(frame: CGRect(x: 0, y: 0, width:
                  collectionView.frame.width, height: collectionView.frame.height))
                view.set(title: "Cafes")
                view.set(desc: "No cafes found.")
                collectionView.backgroundView = view
            }
            collectionView.reloadData()
        }
    }
    
    func setupTitle() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        if let city = selectedCity?.city, let state = selectedCity?.state {
            title = "\(city.uppercased()), \(state.uppercased())"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func showCafeDetail(segue:UIStoryboardSegue){
        if let viewController = segue.destination as?
            CafeDetailViewController,
            let index = collectionView.indexPathsForSelectedItems?
                        .first {
            selectedCafe = manager.cafeItem(at: index)
            viewController.selectedCafe = selectedCafe
        }
    }


}

// MARK: UICollectionViewDataSource
extension CafeListViewController: UICollectionViewDataSource {
    // code goes here
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //1
        return manager.numberOfItems()
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return collectionView.dequeueReusableCell(withReuseIdentifier:
//        "cafeCell", for: indexPath)
//
//    }
    
    func collectionView(_ collectionView: UICollectionView,
         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                   "cafeCell", for: indexPath) as! CafeCell
        let item = manager.cafeItem(at: indexPath)
        if let name = item.name { cell.lblTitle.text = name }
        if let cuisine = item.subtitle { cell.lblCuisine.text = cuisine}
        if let image = item.imageURL {
            if let url = URL(string: image) {
                let data = try? Data(contentsOf: url)
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.imgCafe.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }

    
}

