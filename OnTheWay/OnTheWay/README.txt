OnTheWay

This directory contains the files you will need for the OnTheWay application.

AppDelegate.swift
	Runs the application, contains the main function.

Info.plist
	Contains build settings for the application.

RoutesViewController.swift
	Class that creates the routes table display. It populates the table 
using the information sent to it from the StartViewController class.

StartViewController.swift
	Class that creates the start screen of the application. It handles the user input and 
sends information to other objects when the user performs an action.

BridgingHeader.h
	Contains dependency information to get Google Maps SDK to work.

RouteOptions.swift
	Calculates and stores information about all the possible routes based on which
waypoint could possibly be chosen.

WaypointOption.swift
	Class that contains information about a possible waypoint such as the name, address, 
latitude, and longitude of the waypoint. It also contains the time and distance the route 
would take to go through that waypoint.

JsonURL.swift
	Class with member functions that parse a JSON file to obtain certain information.

AppleMapViewController.swift
	Class that creates the map and puts it on the screen. It draws the start, stop, and
waypoint on the map and draws a polyline between these points to display the route.