import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["code"]

	toggle(event) {
		
		//hide the broadcast message
		this.codeTarget.classList.toggle("hidden")

	}

}