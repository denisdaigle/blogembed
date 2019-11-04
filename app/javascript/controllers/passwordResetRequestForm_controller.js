import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["emailInput", "emailError", "errorMessage", "form", "processingMessage", "processingMessageHolder"]
	
	request(event) {
		
		//hide all errors that may be open.
		this.emailErrorTarget.classList.add("hidden")
		this.errorMessageTarget.classList.add("hidden")
		
		if(this.emailInputTarget.value == ""){
			//inform the user.
			this.emailErrorTarget.textContent = "Please provide your log in email"
			this.emailErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.processingMessageTarget.textContent = "Processing, one moment please"
			this.processingMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

} 