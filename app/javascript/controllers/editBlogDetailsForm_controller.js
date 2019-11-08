import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["form", "blogNameInput", "blogNameError", "errorMessage", "errorMessageHolder", "processingMessage", "processingMessageHolder"]
	
	create(event) {
		
		//hide all errors that may be open.
		this.blogNameErrorTarget.classList.add("hidden")
		this.errorMessageTarget.classList.add("hidden")
		
		if(this.blogNameInputTarget.value == ""){
			//inform the user.
			this.blogNameErrorTarget.textContent = "Please provide a name for this blog"
			this.blogNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.processingMessageTarget.textContent = "Saving. one moment please"
			this.processingMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

} 