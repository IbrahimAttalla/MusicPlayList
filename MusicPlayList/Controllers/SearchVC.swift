//
//  SearchVC
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var musicList = [Music]() // convert to MusicListVM
    let interactor = Interactor()

    @IBOutlet weak var musicListTV: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var searchQuary: UISearchBar!
    
    
    lazy var viewModel: MusicListVM = {
        return MusicListVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Init the static view
        initView()
        
        // init view model
        initVM()

        
        
         //   ( X )    in mvvm  controller and view should not start or stop this progres , OR show & hide any thing like table view or any other view ,
// ==>>        progress.startAnimating()
        
        searchQuary.text = "love"
        //   ( X )    in mvvm  controller and view should not depend on API ( another dependency ) ,  because API like (alamofire ,sessions) is a ( black box )that can't be tested be test through Mock , my code ( white box )   is the only one that i can test not another code like (alamofire ,sessions) ,
// ==>>  firstLoad()
        
        //   ( X )    in mvvm  controller and view  should not do  convert date  ( presentational logic )
        
        //   ( 🧐 )If you plan to write tests for the SearchVC, we’ll find ourselves stuck since it’s too complicated
        //   We have to mock the APIService, mock the table view and mock the cell to test the whole  PhotoListViewController
        
        //   ( ⩗ ) every func should have one and single responsabelity
        
        //   ( 😎 ) Remember that we want to make writing tests easier?  Let’s try MVVM approach!
        
        
        
         /*
         
         Try MVVM
         • In order to solve the problem, our first priority is to clean up the view controller
         • Split the view controller into two parts: the View and the ViewModel.
         • To be specific, we are going to: – Design a set of interfaces for binding.
         – Move the presentational logic and controller logic to the ViewModel.
 
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func initView() {
        self.navigationItem.title = "Search Here"
        musicListTV.estimatedRowHeight = 150
        musicListTV.rowHeight = UITableView.automaticDimension
    }
    
    func initVM() {
        
        // Naive binding
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch self.viewModel.state {
                case .empty, .error:
                    self.progress.stopAnimating()
                    self.progress.isHidden = true

                    UIView.animate(withDuration: 0.2, animations: {
                        self.musicListTV.alpha = 0.0
                    })
                case .loading:
                    self.progress.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.musicListTV.alpha = 0.0
                    })
                case .populated:

                    self.progress.stopAnimating()
                    self.progress.isHidden = true

                    UIView.animate(withDuration: 0.2, animations: {
                        self.musicListTV.alpha = 1.0

                    })
                }
            }
        }
        
        // this closure will fired when Music API get response
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.musicListTV.reloadData()
            }
        }
        
        
        // here is my first  implemetantion of [weak self] to avoid retain cycle & guard let self = self else { return } to avoid call any thing if self (this view) not appear
        viewModel.startFetchingMusicListClosure = { [weak self] in
            guard let self = self else { return }
            // next func that call music list Api
            self.viewModel.fetchMusicList(searchText: "love")
        }
        viewModel.initFetchToken()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


extension SearchVC :UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! musicCell
        cell.selectionStyle = .none
        let cellVM = viewModel.getCellViewModel( at: indexPath )
        cell.musicListCellMV = cellVM

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemDetailsVM = viewModel.getCellViewModel( at: indexPath )
        performSegue(withIdentifier: "detailsSeg", sender: itemDetailsVM)
//        performSegue(withIdentifier: "detailsSegu", sender: nil)

    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailsSegu" {
//                let controller = segue.destination as! SecondVC
//
////                controller.transitioningDelegate = self
////                controller.interactor = interactor
//
//        }
//    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSeg" {
            if let indexPath = self.musicListTV.indexPathForSelectedRow {
                let controller = segue.destination as! DetailsVC

                print(" ✅ ✅  your selection is  ",viewModel.getCellViewModel( at: indexPath ))
                let itemDetailsVM = viewModel.getCellViewModel( at: indexPath )
                controller.musicListCellMV = itemDetailsVM
//                controller.transitioningDelegate = self
//                controller.interactor = interactor
            }
        }
    }
}

extension SearchVC: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension SearchVC: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchQuary.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuary.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.fetchMusicList(searchText: searchText)
    }
}
