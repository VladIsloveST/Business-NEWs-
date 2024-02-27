## Hi there, I'm Vladislav :relaxed:

### Business news

_Welcome to short guide about my project. The Business-NEWs app brings you top business headlines from TechCrunch right now, all articles published by the Wall Street Journal in the last 6 months._

Setting the window's `rootViewController`, represented by the TabBarController() object, happens in the SceneDelegate. 

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        let mainController = TabBarController()
        mainController.selectedIndex = 1
        self.window?.rootViewController = mainController
        window?.makeKeyAndVisible()
    }
```
* ### TabBarController

TabBarController has 2 standard screens and one implemented as a bottom sheet.

A CustomTabBar, that has a button and an empty `didTapButton` closure, set in TabBarController.

In the TabBarController is created a `routeToSettings` function, in which the SettingsViewController is initialized, configured and the `present(_: animated:)` function is called.

```swift
fileprivate func routeToSettings() {
        if #available(iOS 15.0, *) {
            let settingsVC = SettingsAssembly.assembleSettings()
            (settingsVC as? SettingsViewController)?.delegate = self
            let homeViewController = containerViewController?.navgationController.viewControllers.first
            (settingsVC as? SettingsViewController)?.settingDelegateHome = (homeViewController as? SettingViewControllerDelegate)
            (settingsVC as? SettingsViewController)?.settingDelegateSaved = selectedArticlesViewController!
            present(settingsVC, animated: true)
        }
    }
```

The `routeToSettings` function is placed in an empty `didTapButton` closure, that runs when the button is pressed.  As soon as the SettingsViewController appears, the bottom screen becomes inactive, its alpha is reduced to 0.9.

```swift
fileprivate func configureTabBar() {
        setValue(CustomTabBar(frame: tabBar.frame), forKey: "tabBar")
        delegate = self
        tabBar.tintColor = .label
        view.backgroundColor = .white
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.didTapButton = { [unowned self] in
            view.alpha = 0.9
            view.isUserInteractionEnabled = false
            self.routeToSettings()
        }
    }
```

This creates a visual effect in which the TabBar has three full-fledged elements.

> You ask me, why make everything so complicated.

The fact is that SettingsViewController appears as a bottom sheet, and not as a full screen. 

_The idea is taken from_ __Safari__.

<img width="368" alt="Safari" src="https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/42e30234-05b3-4423-91e4-e2d5a90c866b">
<img width="368" alt="Settings" src="https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/da2b9ebf-cee3-4fb1-972e-33e4976c6933">


Let's go to each screen in order.

* ### SelectedArticleViewController

The SelectedArticleViewController object is responsible for the first element in the TabBar, where saved articles are displayed. Searching with searchBar, which appears animatedly, is also implemented.

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/46d16c61-686c-449a-8b5e-3a070a66d242


The `coreDataManager` property is of type CoreDataProtocol and is initialized in `viewDidLoad()`. All the logic of interaction with CoreData is implemetnted in the CoreDataManager class. Only the presentation logic is implemented in the SelectedArticleViewController class.

Depending on the value of the `isSelected` flag, which array _(savedArticles/searchArticles)_ to display in the collectionView is selected.

The `searchBar(_: textDidChange:)` UISearchBarDelegate function changes the value of the flag, fills and empties the `searchArticles` array.

```swift
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, !text.isEmpty {
            isSearching = true
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
                self?.searchedArticles = self?.coreDataManager.searchArticles(with: text.lowercased()) ?? []
            })
        } else {
            isSearching = false
            searchedArticles.removeAll()
        }
        savedCollectionView.reloadData()
    }
```

- ### SettingsViewController

_App supports dark/light mode, notification settings, language change._

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/f10b98fb-8b65-4741-b201-01bcc813d375

The logic of saving settings is implemented in the SettingsManager class. Settings are stored in UserDefaults.

- The dark/light mode is implemented using CustomSettingViewCell's function named `setupSwitcher(isOn:didChageSetup:)`

   - `isOn` - the swicher value, which is obtained using the getter of SettingsManager‘s `isDark` property

   - In `didChageSetup` @escaping closure is placed:
     *	setting a new value of the `isDark` SettingsManager's property;
     *	calling `changeTheme()` function in HomeSettingDelegate and SavedSettingDelegate.
Сlosure is activated when toggling the switched.

```swift
cell.setupSwitcher(isOn: self.settingManager.isDark) { [weak self] isDark in
    self?.settingManager.isDark = isDark
    self?.settingDelegateHome?.changeThema()
    self?.settingDelegateSaved?.changeThema()
}
```

* The notification setting works according to the same principle.

  * `isOn` - the swicher value, which is obtained using the getter of SettingsManager‘s `isNotify` property

  * Another implementation is placed only in the closure. Setting SettingsManager's `isNotify` property. Depending on the value of `isNotify`, one or another block of code is triggered.  
      * In the first case, this is a permission check and going to the system settings to enable notifications globally. 
      * And in the second, it's the cancellation of notifications
```swift
cell.setupSwitcher(isOn: self.settingManager.isNotify) { [weak self] isNotify in
    self?.settingManager.isNotify = isNotify
    if isNotify {
        self?.localNotification.checkForPermission()
        self?.localNotification.directToSettings { cell.switcher.isOn = false }
    } else {
        self?.localNotification.removeNotification()
    }
}
```

The notification logic is implemented in the LocalNotification class. The SettingsViewController interacts with it through a protocol.

* The application supports English/German languages. Changing the language is implemented using the `setupSegmentControl(selected:didChageLanguage:)` function, but already using UISegmentControl.

In the `didChageLanguage` closure, a new value of SettingsManager’s `language` property is set and the `showAlertCloseApp()` function is called, where a UIAlertController is created, the handler of which causes a notification and closes the application.

```swift
let index = Language.allCases.firstIndex(of: settingManager.language) ?? 0
cell.setupSegmentedControl(selected: index) { [weak self] selectedIndex in
    self?.settingManager.language = Language.allCases[selectedIndex]
    self?.showAlertCloseApp()
}
```

* ### HomeViewController

_HomeViewController is more complex than the previous two Views._

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/0409b8f1-3683-4923-a19a-34dd17a22ec1

To implement the side menu as a single object with the HomeViewController, create a ContainerViewController that combines the Menu and HomeView.  When Menu appears, HomeView is inactive and its alpha is 0.9. 

```swift
private func toggleMenu(complition: (() -> Void)? ) {
    let homeViewController = (self.navgationController.viewControllers.first as? HomeViewController)
    switch menuState {
    case .closed:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0, options: .curveEaseIn) {
            self.navgationController.view.frame.origin.x = (self.navgationController.view.frame.size.width) / 2.5
            homeViewController?.view.alpha = 0.95
            homeViewController?.view.isUserInteractionEnabled = false
        } completion: { [weak self] done in
            if done {
                self?.menuState = .opened
            }
        }
        
    case .opened:
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0, options: .curveEaseOut) {
            self.navgationController.view.frame.origin.x = 0
            homeViewController?.view.alpha = 1
            homeViewController?.view.isUserInteractionEnabled = true
        } completion: { [weak self] done in
            if done {
                self?.menuState = .closed
                DispatchQueue.main.async {
                    complition?()
                }
            }
        }
    }
}

```

Menu has dynamic cells that deploy when clicked.

```swift
// MARK: - Table View DataSource
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        menuSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = menuSections[section]
        return currentSection.isOpened ? (currentSection.options.count + 1) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = menuSections[indexPath.section].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: size)
        } else {
            cell.textLabel?.text = menuSections[indexPath.section].options[indexPath.row - 1].rawValue
            cell.textLabel?.font = UIFont(name: "Avenir Light Oblique", size: size)
            cell.layoutMargins.left = 30
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            menuSections[indexPath.section].isOpened = !menuSections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .fade)
        } else {
            let item = menuSections[indexPath.section].options[indexPath.row - 1]
            delegate?.didSelect(menuItem: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
```

In the horizontal CollectionView places the vertical ones in which the articles are displayed.

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/f1aa3d2a-280a-4e6c-bbf2-03b75f10a4f8

_The idea is taken from_ __Telegram__.

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/84494206-76fe-4f0f-8e78-5f25fd5ebd4f

The logic of downloading and updating articles is carried out in the presenter, where they are put in a multidimensional array. Upon successful upload, the photo is stored in cash for instant display and to avoid re-uploading. The caching logic is implemented in the CashManager class.

To optimize time, the call to download articles of the first 4 categories is set in the initializer of the presenter.  Other categories is loaded in HomeViewController’s `viewDidAppear()` function. Thus, the loading time is cut in half.

When the navigation bar is pressed, the `scrollTop` closure is activated, after which the display of articles moves up.

The display of articles is made using CustomCompositionalLayout. 
```swift
private func createLayout() -> CustomFlowLayout {
    let topItem = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(1)))
    let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(140)))
    let localVerticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(400)),
        repeatingSubitem: item, count: 3)
    let generalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .estimated(400)),
        subitems: [topItem, localVerticalGroup])
    generalGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
    let section = NSCollectionLayoutSection(group: generalGroup)
    section.interGroupSpacing = 80
    let layout = CustomFlowLayout(section: section, numberOfItemsInSection: 4)
    return layout
}
```

Separators are added to the CustomFlowLayout class. 

<img width="368" alt="The Economist" src="https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/1e33b41b-281a-41f1-9961-16ee2c8cadc9">

_The idea is taken from_ __The Economist__.

First cell in the group has a dynamic height change depending on the size of the image, which allows you to avoid distortion and cropping of the image. 

```swift
class ResizableImageView: UIImageView {
    override var image: UIImage? {
        didSet {
            guard let image = image else { return }
            if superview != nil {
                let aspectRatio = superview!.frame.width / image.size.width
                let resizeConstraints = [
                    self.widthAnchor.constraint(equalToConstant: image.size.width * aspectRatio),
                    self.heightAnchor.constraint(equalToConstant: image.size.height * aspectRatio)
                ]
                addConstraints(resizeConstraints)
            }
        }
    }
}
```

Each cell has a save and share button. Clicking on a cell will take you to the Web resource.
```swift
extension ArticlesCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: articles[indexPath.row].url) {
            UIApplication.shared.open(url)
        }
    }
}
```
Articles are distributed by ArticleCollectionViewCell depending on indexPath.row in `cellForItemAt` function. Parameters, passed in `didFetchData` closure, are responsible for updating and loading data. 
```swift
let articles = presenter.typesOfArticles[indexPath.row]
cell.fill(articles: articles) { [weak self] (page, isRefreshed) in
    self?.presenter.getArticlesFromCategory(index: indexPath.row, page: page, isRefreshed: isRefreshed)
}
```
When refreshing, only the first 12 articles are loaded. 

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/3b26fae3-9cba-409f-85cb-8f4f392b9797

```swift
@objc
private func refresh(sender: UIRefreshControl) {
    didFetchData(1, true)
    sender.endRefreshing()
}
```
Then prefetching is activated, which loads the next page with 12 new articles.
```swift
extension ArticlesCollectionViewCell: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let filtered = indexPaths.filter({ $0.row >= articles.count - 4 })
        if filtered.count > 0 {
            page += 1
            self.didFetchData(page, false)
        }
    }
}
```
CategoryCollectionView is the last item on this screen that is not considered.

https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/6c4fee30-4ddb-49ed-8117-e44cbc7475f1

When switching to another category, the `underlineView` indicator is triggered, which highlights the selected category. The indicator dynamically changes leftAnchor and its length depending on the size of the category name. 
```swift
private func calculateCategoryWidth(item: Int) -> CGFloat {
    let categoryFont = UIFont(name: "Arial Bold", size: 18)
    let categoryAttributes = [NSAttributedString.Key.font : categoryFont]
    let categoryWidth = nameCategoryArray[item].size(withAttributes: categoryAttributes
                                                     as [NSAttributedString.Key : Any]).width + 20
    return categoryWidth
} 
```

Аlso increases the font and alpha of the selected category, implemented in CategoryCell.
```swift
override var isSelected: Bool {
    didSet {
        nameCategoryLabel.alpha = self.isSelected ? 1 : 0.95
        nameCategoryLabel.font = self.isSelected ?
        UIFont(name: "Helvetica Neue Bold", size: 18) :
        UIFont(name: "Helvetica Neue Medium", size: 18)
    }
}
```
You can switch to another category by swiping, which calls the HomeViewController's `scrollViewWillEndDragging` function 
```swift
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        categoryCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        categoryCollectionView.animateMovementUnderlineView(item: indexPath.item)
    }
}
```

And by simply clicking on the selected category, which calls the CategoryCollectionView's `didSelectedItemAt` function.
```swift
extension CategoryCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        homeControllerDelegate?.scrollToCategory(at: indexPath.item)
        animateMovementUnderlineView(item: indexPath.item)
    }
}
```

CategoryCollectionView and HomeViewController interact through a delegate.

The HomeRouter class is responsible for the logic of switching to the SearchViewController. In HomePresenter, the `showSearch` function calls push from the HomeRouter class.

* ### SearchViewController

The logic of loading articles, like in HomeViewController, is placed in the presenter.

SearchBar is added to CollectionView‘s SupplementaryItem in the `viewForSupplementaryElementOFKind` function.



https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/29291dbd-0f08-4306-a29c-c6ba0df148e0



_The idea of displaying the search history is taken from_ __YouTube__, but with the addition of animation.

<img width="368" alt="YouTube" src="https://github.com/VladIsloveST/Business-NEWs-/assets/99729302/2d962f09-8ce7-4fc0-b034-d82736f5e789">


After click on the SearchBar, the history appears.
```swift
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text, !text.isEmpty else { return flowUp() }
        
        flowDown()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.presenter.search(line: text.lowercased(), page: 1)
            self?.historyTableView.added(item: text)
            self?.historyTableView.reloadData()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        flowUp()
    }
}
```

When you click on the CollectionView, the history disappears.
```swift
let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flowDown))
gestureRecognizer.numberOfTapsRequired = 1
searchResultCollectioView.addGestureRecognizer(gestureRecognizer)
gestureRecognizer.cancelsTouchesInView = false
```

The HistoryTableView class is responsible for the history display logic. You can delete, reverse, search an element of the search history.  SerchViewController and HistoryTableView interact through a delegate.
```swift
extension SearchViewController: PopOverTableViewDelegate {
    func selectItem(row: Int,  with action: Action) {
        switch action {
        case .delete:
            self.heightAnchorDown?.constant = self.historyTableView.contentSize.height
        case .revert:
            searchBar.text = historyTableView.mockData[row]
        case .search:
            let selectedRow = historyTableView.mockData[row]
            loadingIndicator.isAnimating = true
            searchBar.text = selectedRow
            presenter.search(line: selectedRow, page: 1)
            flowDown()
        }
    }
}
```
