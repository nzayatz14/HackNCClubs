//
//  CalenderHandlerBackend.swift
//  HackNCClubs
//
//  Created by Nick Zayatz on 10/10/15.
//  Copyright © 2015 Nick Zayatz. All rights reserved.
//

import Foundation
import UIKit
import EventKit

let calenderTitle = "HackNCClubs"
let sharedCalenderHandler = CalenderHandlerBackend()

class CalenderHandlerBackend: NSObject {
    
    
    override init(){
        super.init()
        
    }
    
    
    /**
    Fetches the new events from the server
    
    - parameter void:
    - returns: void
    */
    func fetchEvents(){
        
    }
    
    
    /**
    If the user does not have a calender for this app, create one
    
    - parameter store: the store being used to create this calender
    - returns: void
    */
    func createCalender(store: EKEventStore){
        let calender = EKCalendar(forEntityType: EKEntityType.Event, eventStore: store)
        calender.title = calenderTitle
        
        var source: EKSource?
        
        for var sources in store.sources {
            if sources.sourceType == EKSourceType.CalDAV && sources.title == "iCloud" {
                source = sources
                break
            }
        }
        
        if let Source = source {
            calender.source = Source
            
            do {
                _ = try store.saveCalendar(calender, commit: true)
            }catch let error as NSError {
                print("Error - \(error)")
            }
        }
    }
    
    
    /**
    Function called to sync events to the users calender
    
    - parameter void:
    - returns: void
    */
    func syncEventsToCalender(){
        let eventStore = EKEventStore()
        
        var goodToGo = false
        
        //request calender access if necessary
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            goodToGo = true
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion:
                { (granted: Bool, error: NSError?) in
                    if granted {
                        goodToGo = true
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case Default")
        }
        
        //if we have access, sync the events
        if goodToGo {
            
            print("create event")
            let startDate = NSDate()
            // 2 hours
            let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
            
            
            let event = EKEvent(eventStore: eventStore)
            
            //get stuff from dictionaries
            event.title = "New Meeting"
            event.startDate = startDate
            event.endDate = endDate
            insertEvent(eventStore, event: event)
        }
    }
    
    
    /**
    Function called to insert an event into our calender
    
    - parameter store: the store that holds our calender
    - parameter event: the event being added to the calender
    - returns: void
    */
    func insertEvent(store: EKEventStore, event: EKEvent){
        
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        //if the calender does not yet exist, create it
        var hasCalender = false
        for calender in calendars {
            if calender.title == calenderTitle {
                hasCalender = true
                break
            }
        }
        
        if !hasCalender {
            createCalender(store)
        }
        
        
        //loop through the calenders to find ours
        for calendar in calendars {
            if calendar.title == calenderTitle {
                
                // Save Event in Calendar
                event.calendar = calendar
                do {
                    _ = try store.saveEvent(event, span: EKSpan.ThisEvent)
                    
                }catch let theError as NSError {
                    print("An error occured \(theError)")
                }
            }
        }
    }
    
}