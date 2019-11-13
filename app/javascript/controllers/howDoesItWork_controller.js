import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["content"]

	toggle(event) {
		
		//hide the broadcast message
		this.contentTarget.classList.toggle("hidden")

	}

}