//
//  TabBarRouter.swift
//  TheMovieDB
//
//  Created by Usuario on 28/01/20.
//  Copyright (c) 2020 Usuario. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol TabBarRoutingLogic
{
}

protocol TabBarDataPassing
{
  var dataStore: TabBarDataStore? { get }
}

class TabBarRouter: NSObject, TabBarRoutingLogic, TabBarDataPassing
{
  weak var viewController: TabBarViewController?
  var dataStore: TabBarDataStore?
  
  // MARK: Routing
}
