import UIKit

final class TabBarController: UITabBarController {
    
    private let tabBarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.setValue(tabBarView, forKey: "tabBar")
        setupVCs()
        self.selectedIndex = 0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupVCs() {
        viewControllers = [
            createNavController(for: MainVC(), image: UIImage(systemName: "house.fill")!),
            createNavController(for: SearchVC(), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: SettingsVC(), image: UIImage(systemName: "gear")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = image
        navController.tabBarItem.title = nil
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
    
    private func generateVC(viewController: UIViewController, image: UIImage, title: String?) -> UIViewController {
        viewController.tabBarItem.image = image
        return viewController
    }
}

extension TabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let tabBar = tabBar as? TabBarView {
            tabBar.updateCurveForTappedIndex()
        }
    }
}

