//
//  MainMap.swift
//  MapboxScratchpad
//
//  Created by Jim Margolis on 10/31/24.
//

import UIKit
import MapboxMaps
import SwiftUI

class MainMapViewController: UIViewController, ObservableObject, AnnotationInteractionDelegate {
    var mapView: MapView!
    var pointAnnotationManager: PointAnnotationManager?
    private let customImage = UIImage(named: "pin")!

    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        mapView = MapView(frame: frame)
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager?.delegate = self

        let cameraOptions = CameraOptions(center:
            CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
            zoom: 12, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(mapView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addWaypointAtCenter() {
        let centerCoordinate = mapView.mapboxMap.cameraState.center
        var waypoint = PointAnnotation(coordinate: centerCoordinate)
        waypoint.isDraggable = true
        waypoint.image = .init(image: customImage, name: "pin")
        pointAnnotationManager?.annotations = [waypoint]
    }
    
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        // Called when the annotation is being dragged
        if var annotation = annotations.first as? PointAnnotation {
            annotation.iconSize = 1.2
        }
    }

    func annotationManager(_ manager: AnnotationManager, didEndDraggingAnnotations annotations: [Annotation]) {
        // Called when dragging ends
        if var annotation = annotations.first as? PointAnnotation {
            annotation.iconSize = 1
        }
    }
}

struct MainMap: UIViewControllerRepresentable {
    @ObservedObject var mainMapViewController: MainMapViewController

    func makeUIViewController(context: Context) -> MainMapViewController {
        return mainMapViewController
    }

    func updateUIViewController(_ uiViewController: MainMapViewController, context: Context) {
    }
}
