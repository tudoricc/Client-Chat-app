//
//  ChatView.swift
//  ChatClien
//
//  Created by Tudor on 07/08/14.
//  Copyright (c) 2014 meforme. All rights reserved.
//

import UIKit

class ChatView: UIViewController,NSStreamDelegate {
    
    
    
    var readStream:Unmanaged<CFReadStream>?;
    var writeStream:Unmanaged<CFWriteStream>?     ;
    var inputStream : NSInputStream!
    var outputStrean : NSOutputStream!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.initNetworkCommunication()
        // Do any additional setupnumberOfRowsInSectionew.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    @IBOutlet var BackButton: UIButton!

    @IBOutlet var PersonLabel: UILabel!
    @IBOutlet var MessageTable: UITableView!
    
    
    func initNetworkCommunication() {
        
        
        //  declari niste stream-uri din care citesti si in care  scrii
        
        //
        
        
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,"localhost",8023,&readStream,&writeStream)
        //print("\(inputStream.description)")
        inputStream = self.readStream!.takeUnretainedValue()
        outputStrean = self.writeStream!.takeUnretainedValue()
        
        self.inputStream!.delegate=self
        self.outputStrean!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStrean!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream.open()
        self.outputStrean.open()
        
        
        
    }

}
