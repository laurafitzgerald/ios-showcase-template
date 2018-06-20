//
//  RootRouter.swift
//  ios-showcase-template
//
//  Created by Wei Li on 08/11/2017.
//

import AGSAuth
import Foundation
import UIKit

/*
 The router for the root view module. It is responsible to load child modules and attach them to the view.
 It should call the child module's corresponding builder class to build the child module, pass on the dependencies that are required.
 */
protocol RootRouter {
    var appComponents: AppComponents { get }
    var rootViewController: RootViewController { get }

    func launchFromWindow(window: UIWindow)
    func launchHomeView()
    func launchAuthenticationView()
    func launchStorageView()
    func launchDeviceTrustView()
    func launchPushView()
    func launchMetricsView()
    func launchURL(_ urlString: String)
    func openDocsPage(withLink docUrl: DocsURL, andTitle title: String)
}

class RootRouterImpl: RootRouter {
    let navViewController: UINavigationController
    let rootViewController: RootViewController
    let appComponents: AppComponents

    var homeRouter: HomeRouter?
    var authenticationRouter: AuthenticationRouter?
    var storageRouter: StorageRouter?
    var deviceTrustRouter: DeviceTrustRouter?
    var pushRouter: PushRouter?
    var metricsRouter: MetricsRouter?
    var webviewRouter: WebviewRouter?

    init(navViewController: UINavigationController, viewController: RootViewController, appComponents: AppComponents) {
        self.navViewController = navViewController
        self.rootViewController = viewController
        self.appComponents = appComponents
    }

    func launchFromWindow(window: UIWindow) {
        window.rootViewController = self.navViewController
        window.makeKeyAndVisible()
    }

    func launchHomeView() {
        if self.homeRouter == nil {
            self.homeRouter = HomeBuilder().build()
        }
        self.rootViewController.title = RootViewController.MENU_ITEM_TITLE_HOME
        self.rootViewController.presentViewController(self.homeRouter!.viewController, true)
    }

    func launchAuthenticationView() {
        if self.authenticationRouter == nil {
            let authViewOptions = AuthenticationViewOptions(authLoginNavigationTitle: RootViewController.MENU_ITEM_TITLE_IDM_AUTH, authDetailsNavigationTitle: RootViewController.SUBMENU_ITEM_TITLE_IDM_AUTH_DETAILS, titleViewController: self.rootViewController)
            self.authenticationRouter = AuthenticationBuilder(appComponents: self.appComponents, authViewOptions).build()
        }
        self.rootViewController.presentViewController(self.authenticationRouter!.initialViewController(user: self.resolveCurrentUser()), true)
    }

    // Storage View
    func launchStorageView() {
        if self.storageRouter == nil {
            self.storageRouter = StorageBuilder(appComponents: self.appComponents).build()
        }
        self.rootViewController.title = RootViewController.MENU_ITEM_TITLE_SEC_STORAGE
        self.rootViewController.presentViewController(self.storageRouter!.viewController, true)
    }

    // Device Trust View
    func launchDeviceTrustView() {
        if self.deviceTrustRouter == nil {
            self.deviceTrustRouter = DeviceTrustBuilder(appComponents: self.appComponents).build()
        }
        self.rootViewController.title = RootViewController.MENU_ITEM_TITLE_SEC_TRUST
        self.rootViewController.presentViewController(self.deviceTrustRouter!.viewController, true)
    }

    func launchPushView() {
        if self.pushRouter == nil {
            self.pushRouter = PushBuilder().build()
        }
        self.rootViewController.title = RootViewController.MENU_ITEM_TITLE_PUSH_MESSAGE
        self.rootViewController.presentViewController(self.pushRouter!.viewController, true)
    }
    
    func launchMetricsView() {
        if self.metricsRouter == nil {
            self.metricsRouter = MetricsBuilder().build()
        }
        self.rootViewController.title = RootViewController.MENU_ITEM_TITLE_METRICS
        self.rootViewController.presentViewController(self.metricsRouter!.viewController, true)
    }
    
    func launchURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    }

    func resolveCurrentUser() -> User? {
        let authService = self.appComponents.resolveAuthService()
        return try! authService.currentUser()
    }
    
<<<<<<< HEAD
    func openDocsPage(withLink docUrl: DocsURL, andTitle title: String) {
        if self.webviewRouter == nil {
            self.webviewRouter = WebviewBuilder().build()
        }
        self.rootViewController.title = title
=======
    func openDocsPage(withLink docUrl: DocsURL) {
        if self.webviewRouter == nil {
            self.webviewRouter = WebviewBuilder().build()
        }
>>>>>>>  ✨ adding the new view for documentation pages
        self.rootViewController.presentViewController(self.webviewRouter!.viewController, true)
        self.webviewRouter?.viewController.loadUrl(docUrl.toURL())
    }
}
