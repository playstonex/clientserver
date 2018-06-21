//
//  ViewController.swift
//  Fetch
//
//  Created by lei on 2018/5/28.
//  Copyright © 2018 lei. All rights reserved.
//

import UIKit
import JavaScriptCore
import ClientServer_iOS


class ViewController: UIViewController {

    let content = JSContext()
    var manager: CSRequestManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NetRequest.request("https://petal.playstone.org/api/v2/text?q=time&from=zh-CN&to=en&source=baidu") { (result) in
//            print("requesnt finish nativve")
//        }
//
        
        
        
        
        if  let path = Bundle.main.url(forResource: "bundle", withExtension: "js") {
            let manager = CSRequestManager(jsFile: path)
            self.manager = manager;
        
            
            manager?.call("smartTranslate", arguments: ["hello", "zh-CN","en","en"], completeHandle: { (message, err) in
                print(message, err);
            })
            
        }
        
        
    }

    
//    func js() {
//        let log : @convention(block) (String)->Void = { message in
//            print(message)
//        }
//
//        if  let path = Bundle.main.path(forResource: "bundle", ofType: "js"),
//            let scriptString = try? String.init(contentsOfFile: path, encoding: String.Encoding.utf8),
//            let content = self.content {
//
//            content.exceptionHandler = { context, exception in
//                print("JS Error: \(exception?.description ?? "unknown error")")
//            }
//            content.setObject(log, forKeyedSubscript: "log" as NSString)
//            content.evaluateScript(scriptString)
//            content.setObject( NetRequest.classForCoder(), forKeyedSubscript:"NetRequest" as NSString)
//            content.setObject( CSResponse.classForCoder(), forKeyedSubscript:"NetResponse" as NSString)
//
//            let model = content.objectForKeyedSubscript("black")
//
//
//            let callback : @convention(block) (String,String) -> Void = { message, errorInfo in
//                print(message)
//                print(errorInfo)
//            }
//
//
//            let hello = model?.objectForKeyedSubscript("smartTranslate")
//            let r = hello?.call(withArguments: ["hello", "zh-CN","en","en", JSValue(object: callback, in: content) ])
//            print(r)
//
//
//        }
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

