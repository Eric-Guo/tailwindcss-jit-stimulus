// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@fontsource/montserrat";

import "stylesheets/application.css"

import mrujs from "mrujs";
import * as Turbo from "@hotwired/turbo";

// Turbo must be set before starting mrujs for proper compatibility with querySelectors.
window.Turbo = Turbo;

mrujs.start();

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const stimulus = Application.start()
const context = require.context("../controllers", true, /\.js$/)
stimulus.load(definitionsFromContext(context))

window.Stimulus = stimulus;
