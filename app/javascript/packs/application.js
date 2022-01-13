// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// See https://rubyyagi.com/how-to-use-bootstrap-and-jquery-in-rails-6-with-webpacker/
import 'jquery';
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

// Import Bootstrap in the webpack entry point file
import 'bootstrap';
// Fontawesome: https://fontawesome.com/
import "@fortawesome/fontawesome-free/js/all";

import * as L from "leaflet";
import "leaflet/dist/leaflet.css";

Rails.start()
Turbolinks.start()
ActiveStorage.start()


