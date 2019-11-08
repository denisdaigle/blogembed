import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["popup"]
	
	connect() {
	    //do this when it opens.
	}
	
	close(event) {
		
		document.getElementById('popup_holder').innerHTML = ""

	}

}	