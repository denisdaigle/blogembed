import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["tbd"]
	
	connect() {
	    console.log('Main StimulusJS Loaded')
	}

}	