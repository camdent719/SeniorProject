# Albedo App
This iOS app is a proof-of-concept for calculating albedo using an iPhone's camera.

## Camera Files
The following files in the project use the AVFoundation framework to create the camera view that
captures the images:
* AlbedoPhotoCaptureDelegate.swift
* CameraPreviewView.swift
* CameraViewController.swift
* CircularLevel.swift

CameraViewController.swift is the most critical file of the project, as it includes the code that
creates the objects required for the camera.

## View Files
The following files are simple classes that correspond to each view controller of the menu walkthrough.
These classes serve only to save the user’s selection for that given screen to the file
PhotoData.swift. This list of classes is ordered by appearance of the view that they correspond to:
* WelcomeViewController.swift
* SkyViewController.swift
* SnowStateViewController.swift
* PatchinessViewController.swift
* GroundCoverViewController.swift
* SnowSurfaceViewController.swift
* RootViewController.swift
* OptionalDataViewController.swift
* DataViewController.swift

All data that is collected as the user makes menu selections as well as the calculated albedo value is
stored in PhotoData.swift.