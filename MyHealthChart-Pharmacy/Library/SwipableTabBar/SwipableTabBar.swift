//
//  SwipableTabBar.swift
//  My Health Chart-Pharmacy
//
//  Created by Jat42 on 04/10/21.
//

import UIKit

protocol SwipableTabViewControllerDelegate: AnyObject {
    func controllerDidSwipe(to index: Int)
}

// example Page View Controller
class SwipableTabViewController: UIPageViewController {
    
    var swipeControllers: [UIViewController] = []
    
    var swipeDelegate: SwipableTabViewControllerDelegate?
    
    private var previousIndex = 0
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        navigateTo(index: 0)
    }
    
    func navigateTo(index: Int) {
        setViewControllers(
            [swipeControllers[index]],
            direction: previousIndex < index ? .forward : .reverse,
            animated: true,
            completion: nil
        )
        previousIndex = index
        swipeDelegate?.controllerDidSwipe(to: index)
    }
    
}

// typical Page View Controller Data Source
extension SwipableTabViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = swipeControllers.firstIndex(of: viewController) else { return nil }
        
        previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard swipeControllers.count > previousIndex else { return nil }
        
        return swipeControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = swipeControllers.firstIndex(of: viewController) else { return nil }
        
        previousIndex = viewControllerIndex - 1
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < swipeControllers.count else { return nil }
        
        guard swipeControllers.count > nextIndex else { return nil }
        
        return swipeControllers[nextIndex]
    }
    
    
}

// typical Page View Controller Delegate
extension SwipableTabViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let currentIndex = self.viewControllers?.first?.view.tag else { return }
        
        swipeDelegate?.controllerDidSwipe(to: currentIndex)
        
    }
    
}

