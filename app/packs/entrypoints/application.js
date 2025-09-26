// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import "@fontsource/montserrat";

require.context('../images', true)

import "stylesheets/application.css"

import mrujs from "mrujs";
import * as Turbo from "@hotwired/turbo";

// Turbo must be set before starting mrujs for proper compatibility with querySelectors.
window.Turbo = Turbo;

mrujs.start();

import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

window.Stimulus = Application.start()

// Import and register all TailwindCSS Components
import tailwindcssStimulusComponents from "tailwindcss-stimulus-components/dist/tailwindcss-stimulus-components.modern"
Stimulus.register('alert', tailwindcssStimulusComponents.Alert)
Stimulus.register('autosave', tailwindcssStimulusComponents.Autosave)
Stimulus.register('dropdown', tailwindcssStimulusComponents.Dropdown)
Stimulus.register('modal', tailwindcssStimulusComponents.Modal)
Stimulus.register('tabs', tailwindcssStimulusComponents.Tabs)
Stimulus.register('popover', tailwindcssStimulusComponents.Popover)
Stimulus.register('toggle', tailwindcssStimulusComponents.Toggle)
Stimulus.register('slideover', tailwindcssStimulusComponents.Slideover)

const context = require.context("../controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

