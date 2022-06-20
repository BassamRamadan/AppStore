
import UIKit
import SDWebImage

class SearchViewController: UIViewController , UISearchBarDelegate{

    @IBOutlet var AppCollectionView: UICollectionView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppCollectionView.delegate = self
        AppCollectionView.dataSource = self
        
        setupSearchBar()
        initSearchViewModel()
    }
    func initSearchViewModel(){
        // to set closure of observer AppResult with reloadData of AppCollectionView
        self.searchViewModel.appResult.bind { (_) in
            DispatchQueue.main.async {
                self.AppCollectionView.reloadData()
            }
        }
        
        // to set closure of observer AppIndicator with show Activity IndicatorView
        self.searchViewModel.appIndicator.bind{ (indecator) in
            indecator == true ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
        
        searchViewModel.isSearching.bind { [weak self] (isSearching) in
            guard let isSearching = isSearching else { return }
            DispatchQueue.main.async {
                self?.AppCollectionView.alpha = (isSearching ? 0.0 : 1)
            }
        }
        
        searchViewModel.fetchSearchApi()
    }
    
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchViewModel.searchText = searchText
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            self.AppCollectionView.alpha = 0.0
        }
        return true
    }
}



extension SearchViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchViewModel.appResult.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Search", for: indexPath) as? SearchResultCell

        self.searchViewModel.fetchCellData(cell: cell!, row: indexPath.row)
        return cell!
    }
}

