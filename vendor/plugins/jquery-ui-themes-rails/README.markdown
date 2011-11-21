jQuery UI themes for Rails
==========================

All the pre rolled themes for jQuery UI packaged into a gem.

Usage
-----

In your stylesheet manifest include the following

`*= require jquery-ui/<theme name>`

where theme name can be one of the following:

* black-tie
* blitzer
* cupertino
* dark-hive
* dot-luv
* eggplant
* excite-bike
* flick
* hot-sneaks
* humanity
* le-frog
* mint-choc
* overcast
* pepper-grinder
* redmond
* smoothness
* south-street
* start
* sunny
* swanky-purse
* trontastic
* ui-darkness
* ui-lightness
* vader

Helper
------

If you want to take advantage of the Google CDN a helper is included that takes the theme name and optional version (latest used if version is not specified)

Example:

`stylesheet_link_tag jqueryui_css_google_cdn('mint-choc', '1.7.2')`

Rake Task
---------

Includes a rake task which updates the themeroller created file with image-path and moves the new file and images into the asset folder (stylesheets/jquery-ui and images/jquery-ui respectively).

Example:

`rake jquery_ui_themes:import:themeroller[jquery-ui-1.8.16.custom/css/hot-sneaks/jquery-ui-1.8.16.custom.css,hot-sneaks]`

Current theme version
---------------------

The current versions of the themes are for **1.8.16** of [jQuery UI](http://jqueryui.com/ "jQuery UI")

Requirements
------------

Requires Rails 3.1 and higher, or anything that uses the asset pipeline.
