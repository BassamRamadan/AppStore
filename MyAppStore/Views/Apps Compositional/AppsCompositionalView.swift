
import UIKit


class AppsCompositionalView: UIViewController{
    
    @IBOutlet var AppsCollection: UICollectionView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    lazy var appsViewModel: AppsViewModel = {
       return AppsViewModel()
    }()
    
    let headerId = "headerId"
    let categorHeaderId = "categorHeaderId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        AppsCollection.dataSource = self
        AppsCollection.collectionViewLayout = makeCollectionLayout()
        AppsCollection.register(CategoryCell.self, forSupplementaryViewOfKind: categorHeaderId, withReuseIdentifier: headerId)
        initViewModel()
    }
    
    private func makeCollectionLayout() -> UICollectionViewLayout {
        // 1
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0{
                return self.createHeaderHorizontal()
            }else{
                return self.createAppGroups()
            }
        }
                
        // 3
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
            
        return layout
    }
    
    private func createHeaderHorizontal() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
            
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92),
                                                     heightDimension: .estimated(280))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)
        
            
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        return layoutSection
    }
    private func createAppGroups() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.25))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalHeight(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitem: layoutItem, count: 4)
        
        
        let horSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(260))
        let hor = NSCollectionLayoutGroup.horizontal(layoutSize: horSize, subitems: [layoutGroup])
        hor.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5)
        
        
        let layoutSection = NSCollectionLayoutSection(group: hor)
        layoutSection.orthogonalScrollingBehavior = .continuous
        
        layoutSection.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: categorHeaderId, alignment: .topLeading, absoluteOffset: .init(x: 15, y: 5))
        ]
        return layoutSection
    }
    
   
    func initViewModel(){
        appsViewModel.AllCells.bind { (_) in
            DispatchQueue.main.async {
                self.AppsCollection.reloadData()
                self.appsViewModel.appIndicator.value = false
            }
        }
        appsViewModel.appIndicator.bind { (isLoading) in
            if let isLoading = isLoading{
                isLoading ? self.indicator.startAnimating() : self.indicator.stopAnimating()
            }
        }
        
        appsViewModel.headerSocialApps.bind { (_) in
            DispatchQueue.main.async {
                self.AppsCollection.reloadData()
            }
        }
        self.appsViewModel.fetchTopFreeAppsGroup()
    }
}
extension AppsCompositionalView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > 0{
            return self.appsViewModel.getSectionDataCount(section: section-1)
        }
        return self.appsViewModel.getHeaderSocialCount()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? CategoryCell else { return UICollectionReusableView()}
        header.CategoryName.text = self.appsViewModel.getCategorynName(section: indexPath.section)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "banner", for: indexPath) as? HeaderSocialApp
            self.appsViewModel.setSocialCell(cell: cell!, indexPath: indexPath)
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "apps", for: indexPath) as? appCell
            self.appsViewModel.setAppCell(cell: cell!, indexPath: indexPath)
            return cell!
        }
    }
}
