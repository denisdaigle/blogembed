import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["form", "permittedDomainInput", "permittedDomainError", "errorMessage", "errorMessageHolder", "processingMessage", "processingMessageHolder"]
	
	add2(event) {
		
		//hide all errors that may be open.
		this.permittedDomainErrorTarget.classList.add("hidden")
		this.errorMessageTarget.classList.add("hidden")
		
		if(this.permittedDomainInputTarget.value == ""){
			//inform the user.
			this.permittedDomainErrorTarget.textContent = "Domain missing"
			this.permittedDomainErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.processingMessageTarget.textContent = "Saving..."
			this.processingMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

} 