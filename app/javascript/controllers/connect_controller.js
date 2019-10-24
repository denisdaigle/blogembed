import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["thankyou", "form", "input", "error"]
	
	submit() {
		if(this.inputTarget.value == ""){
			//inform the user.
			this.errorTarget.textContent = "Please provide an email address"
			this.errorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if (this.validateEmail() == false) {
			//inform the user.
			this.errorTarget.textContent = "Please provide a valid email address"
			this.errorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.thankyouTarget.textContent = "thank you! An email is on its way!"
			this.thankyouTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

	validateEmail(){
	
		//Validate email format before sending
		var email_validator = new RegExp('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
		
		if (email_validator.test(this.inputTarget.value)) {
			return true
		} else {
			return false
		}
	
	}
} 