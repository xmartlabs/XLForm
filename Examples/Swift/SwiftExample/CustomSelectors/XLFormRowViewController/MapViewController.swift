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
        coordinate = CLLocationCoordinate2D(latitude: -33.0, longitude: -56.0)
        super.init()
    }
}

@objc(MapViewController)
class MapViewController : UIViewController, XLFormRowDescriptorViewController, MKMapViewDelegate {

    var rowDescriptor: XLFormRowDescriptor?
    lazy var mapView : MKMapView = { [unowned self] in
        let mapView = MKMapView(frame: self.view.frame)
        mapView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        return mapView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(mapView)
        mapView.delegate = self
        if let value = rowDescriptor?.value as? CLLocation {
            mapView.setCenter(value.coordinate, animated: false)
            title = String(format: "%0.4f, %0.4f", mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude)
            let annotation = MapAnnotation()
            annotation.coordinate = value.coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
//MARK - - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        pinAnnotationView.pinColor =  MKPinAnnotationColor.red
        pinAnnotationView.isDraggable = true
        pinAnnotationView.animatesDrop = true
        return pinAnnotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (newState == .ending){
            if let rowDescriptor = rowDescriptor, let annotation = view.annotation {
                rowDescriptor.value = CLLocation(latitude:annotation.coordinate.latitude, longitude:annotation.coordinate.longitude)
                self.title = String(format: "%0.4f, %0.4f", annotation.coordinate.latitude, annotation.coordinate.longitude)
            }
        }
    }
    
}




