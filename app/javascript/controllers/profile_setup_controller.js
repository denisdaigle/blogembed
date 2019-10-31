import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ["first_name_input", "last_name_input", "password_input", "first_name_error", "last_name_error", "password_error", "form", "thankyou"]
	
	console.log("Hello, Stimulus!")
	
	submit() {
		if(this.firstNameInputTarget.value == ""){
			//inform the user.
			this.firstNameErrorTarget.textContent = "Please provide your first name"
			this.firstNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.lastNameInputTarget.value == ""){
			//inform the user.
			this.lastNameErrorTarget.textContent = "Please provide your last name"
			this.lastNameErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if(this.passwordInputTarget.value == ""){
			//inform the user.
			this.passwordInputTarget.textContent = "Please provide a password"
			this.passwordInputTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else if (this.validatePassword() == false) {
			//inform the user.
			this.passwordErrorTarget.textContent = "Please provide a stronger password"
			this.passwordErrorTarget.classList.remove("hidden")
			//prevent form submit.
			event.preventDefault()
		} else {
			//allow form submit.
			this.thankyouTarget.textContent = "Thank you! An email is on its way!"
			this.thankyouTarget.classList.remove("hidden")
			this.formTarget.classList.add("hidden")
		}

	}

	validatePassword(){
	
		//Validate email format before sending
		//^                         Start anchor
        //(?=.*[A-Z].*[A-Z])        Ensure string has two uppercase letters.
        //(?=.*[!@#$&*])            Ensure string has one special case letter.
        //(?=.*[0-9].*[0-9])        Ensure string has two digits.
        //(?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
        //.{8}                      Ensure string is of length 8.
        //$                         End anchor.

		var password_validator = new RegExp('^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$');
            
		if (password_validator.test(this.inputTarget.value)) {
			return false
		} else {
			return true
		}
	
	}
} 