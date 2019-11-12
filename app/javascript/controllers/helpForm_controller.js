import { Controller } from "stimulus"

export default class extends Controller {
	
	static targets = ["questionTypeInput", "questionTypeError", "questionInput", "questionError", "emailInput", "emailError", "errorMessage", "form", "processingMessage", "processingMessageHolder"]
	
	send(event) {
		
		//hide all errors that may be open.
		this.questionTypeErrorTarget.classList.add("hidden")
		this.emailErrorTarget.classList.add("hidden")
		this.questionErrorTarget.classList.add("hidden")
		this.errorMessageTarget.classList.add("hidden")
		
		if(this.questionTypeInputTarget.value == ""){
			//inform the user.
			this.questionTypeErrorTarget.textContent = "Please state what this question is about to help us answer it better"
			this.questionTypeErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.questionInputTarget.value == ""){
			//inform the user.
			this.questionErrorTarget.textContent = "Please tell us what your question is"
			this.questionErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.emailInputTarget.value == ""){
			//inform the user.
			this.emailErrorTarget.textContent = "Please provide your email"
			this.emailErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.processingMessageTarget.textContent = "sending, one moment please"
			this.processingMessageHolderTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

} 