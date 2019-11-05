import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["broadcast", "message"]
	
	close(event) {
		
		//hide the broadcast message
		this.broadcastTarget.classList.add("hidden")
		this.messageTarget.textContent = ''

	}

}	