//
//  SearchVC
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var musicList = [Music]()
    @IBOutlet weak var musicListTV: UITableView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    @IBOutlet weak var searchQuary: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.startAnimating()
        searchQuary.text = "love"
        firstLoad()
    }
    
    
    /**
     firstLoad : This method using to Display music list in tableView  .
     
     after calling func getToken if response data not nill , then call func getMusicList by getting it's response data , then flash back to main thread and reload table View based this music list  .
     - returns:  musicList   .
     
     # Example #
     ```
     NetworkService.instance.getToken { (response , error) in
     if response != nil {
     
     NetworkService.instance.getMusicList(params: "love") { (response, error) in
     if response != nil {
        //do things     }
     if error != nil{
        // do things     }
           }
      }
     if error != nil {
                // do things
            }
     }
     
     ```
     
     
     */
    
    func firstLoad(){
        NetworkService.instance.getToken { (response , error) in
            if response != nil {
                self.musicFilter(textQuary: "love")
            }
            if error != nil {
                print("Token API Error == "  , error!)
            }
        }
        
    }
    
    
    func musicFilter(textQuary:String){
        NetworkService.instance.getMusicList(params: textQuary) { (response, error) in
            DispatchQueue.main.async {
                self.progress.stopAnimating()
            }
            if response != nil {
                self.musicList = response!
                DispatchQueue.main.async {
                    self.musicListTV.reloadData()
                }
            }
            if error != nil{
                print(error!)
            }
        }

    }
    
}
extension SearchVC :UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! musicCell
        cell.selectionStyle = .none
        cell.ConfigCell(song: musicList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "detailsSeg", sender: musicList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSeg" {
            if let indexPath = self.musicListTV.indexPathForSelectedRow {
                let controller = segue.destination as! DetailsVC
                controller.song = musicList[indexPath.row]
            }
        }
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
        self.musicFilter(textQuary: searchText)
    }
}
