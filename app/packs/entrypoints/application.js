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
import {Alert, Autosave, Dropdown, Modal, Tabs, Popover, Toggle, Slideover} from "tailwindcss-stimulus-components"
Stimulus.register('alert', Alert)
Stimulus.register('autosave', Autosave)
Stimulus.register('dropdown', Dropdown)
Stimulus.register('modal', Modal)
Stimulus.register('tabs', Tabs)
Stimulus.register('popover', Popover)
Stimulus.register('toggle', Toggle)
Stimulus.register('slideover', Slideover)

const context = require.context("../controllers", true, /\.js$/)
Stimulus.load(definitionsFromContext(context))

