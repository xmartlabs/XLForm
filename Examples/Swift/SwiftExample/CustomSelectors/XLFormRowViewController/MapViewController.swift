//
//  MapViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import MapKit

class MapAnnotation : NSObject, MKAnnotation {
    
    @objc var coordinate : CLLocationCoordinate2D
    
    override init() {
        self.coordinate = CLLocationCoordinate2D(latitude: -33.0, longitude: -56.0)
        super.init()
    }
}

@objc(MapViewController)
class MapViewController : UIViewController, XLFormRowDescriptorViewController, MKMapViewDelegate {

    var rowDescriptor: XLFormRowDescriptor?
    lazy var mapView : MKMapView = {
        let mapView = MKMapView(frame: self.view.frame)
        mapView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        return mapView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        if let rowDesc = self.rowDescriptor {
            if rowDesc.value != nil {
                let coordinate = (self.rowDescriptor!.value as! CLLocation).coordinate
                self.mapView.setCenterCoordinate(coordinate, animated: false)
                self.title = String(format: "%0.4f, %0.4f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude)
                let annotation = MapAnnotation()
                annotation.coordinate = coordinate
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    
//MARK - - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinAnnotationView.pinColor =  MKPinAnnotationColor.Red
        pinAnnotationView.draggable = true
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (newState == MKAnnotationViewDragState.Ending){
            if let rowDescriptor = rowDescriptor, let annotation = view.annotation {
                rowDescriptor.value = CLLocation(latitude:annotation.coordinate.latitude, longitude:annotation.coordinate.longitude)
                self.title = String(format: "%0.4f, %0.4f", annotation.coordinate.latitude, annotation.coordinate.longitude)
            }
        }
    }
    
}




