//
//  DraggableWaypointViewController.swift
//  Mapbox10
//
//  Created by Jim Margolis on 10/31/24.
//


import UIKit
import MapboxMaps
import SwiftUI
import Combine

struct MapboxDraggableWaypointView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> MapViewController {
        return MapViewController()
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
    }
}

// MB 11.7.1 version
// example code: https://docs.mapbox.com/ios/maps/examples/custom-point-annotation/
final class MapViewController: UIViewController {
    private var mapView: MapView!
    private let customImage = UIImage(named: "pin")!
    private var cancelables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate,
                                                                  zoom: 9.0))

        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Allows the delegate to receive information about map events.
        mapView.mapboxMap.onMapLoaded.observeNext { [weak self] _ in
            guard let self = self else { return }
            self.setupExample()

            
            
        }.store(in: &cancelables)
    }

    private func setupExample() {

        // We want to display the annotation at the center of the map's current viewport
        let centerCoordinate = mapView.mapboxMap.cameraState.center

        // Make a `PointAnnotationManager` which will be responsible for managing
        // a collection of `PointAnnotion`s.
        // Annotation managers are kept alive by `AnnotationOrchestrator`
        // (`mapView.annotations`) until you explicitly destroy them
        // by calling `mapView.annotations.removeAnnotationManager(withId:)`
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        // Initialize a point annotation with a geometry ("coordinate" in this case)
        // and configure it with a custom image (sourced from the asset catalogue)
        var customPointAnnotation = PointAnnotation(coordinate: centerCoordinate)
        customPointAnnotation.image = .init(image: customImage, name: "pin")
        customPointAnnotation.isDraggable = true
        customPointAnnotation.iconOffset = [0, 12]
        customPointAnnotation.tapHandler = { [id = customPointAnnotation.id] _ in
            print("tapped annotation: \(id)")
            return true
        }

        customPointAnnotation.dragBeginHandler = { annotation, _ in
            annotation.iconSize = 1.2
            return true // allow drag gesture begin
        }
        customPointAnnotation.dragEndHandler = { annotation, _ in
            annotation.iconSize = 1
        }

        // Add the annotation to the manager in order to render it on the map.
        pointAnnotationManager.annotations = [customPointAnnotation]
    }
}



struct DraggableWaypointView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> DraggableWaypointViewController {
        return DraggableWaypointViewController()
    }

    func updateUIViewController(_ uiViewController: DraggableWaypointViewController, context: Context) {
        
    }
}

// MB10 example using pointAnnotationManager.delegate
class DraggableWaypointViewController: UIViewController, AnnotationInteractionDelegate {

    private var mapView: MapView!
    private var pointAnnotationManager: PointAnnotationManager!
    private let customImage = UIImage(named: "pin")!

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Center the map camera over New York City
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate,
                                                                  zoom: 9.0))

        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)

        // Create a PointAnnotationManager for the draggable waypoint
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.delegate = self  // Set delegate to handle drag events

        // Set up the draggable annotation
        var waypoint = PointAnnotation(coordinate: centerCoordinate)
        waypoint.image = .init(image: customImage, name: "pin")
        waypoint.isDraggable = true  // Enable dragging

        // Add the annotation to the map
        pointAnnotationManager.annotations = [waypoint]
    }

    // MARK: - AnnotationInteractionDelegate

    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        // Called when the annotation is being dragged
        if let annotation = annotations.first as? PointAnnotation {
            print("Dragging annotation at \(annotation.point.coordinates)")
        }
    }

    func annotationManager(_ manager: AnnotationManager, didEndDraggingAnnotations annotations: [Annotation]) {
        // Called when dragging ends
        if let annotation = annotations.first as? PointAnnotation {
            print("Finished dragging annotation at \(annotation.point.coordinates)")
        }
    }
}
